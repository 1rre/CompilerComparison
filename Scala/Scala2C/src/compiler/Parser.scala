package compiler

import scala.util.parsing.combinator.RegexParsers

object Parser extends RegexParsers {
  val name = """\b[_a-zA-Z0-9]+\b""".r ^^ (Variable(_))
  val intLiteral = "[0-9]+".r ^^ (IntLiteral(_))
  val mainFun = """\bobject\b""".r ~ name ~ """\bextends\b""".r ~ """\bApp\b""".r
  val basicExpr = intLiteral ||| name ||| ("(" ~> expr <~ ")")
  def operationMulDiv: Parser[Token] = (basicExpr ~ ("""[*\/%]""".r ~ operationMulDiv).?) ^^ {
    case x ~ Some(y ~ z) => Operation(x, y, z)
    case x ~ None => x
  }
  def operationAddSub: Parser[Token] = (operationMulDiv ~ ("""[+-]""".r ~ operationAddSub).?) ^^ {
    case x ~ Some(y ~ z) => Operation(x, y, z)
    case x ~ None => x
  }
  def expr = operationAddSub
  val println = """\bprintln\b""".r ~ "(" ~> expr <~ ")" ^^ (Println(_))
  val returnStatement = """\breturn\b""".r ~> expr ^^ (Return(_))
  val valDecl = """\bval\b""".r ~> name ~ ("=" ~> expr) ^^ (x => ValDecl(x._1, x._2))
  val statement = (valDecl ||| println ||| returnStatement) <~ ";"
  val body = "{" ~> statement.* <~ "}"
  val program = mainFun ~> body
}