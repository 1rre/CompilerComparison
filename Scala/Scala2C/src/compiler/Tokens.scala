package compiler

sealed trait Token
case class Variable(name: String) extends Token {
  override def toString = name
}
case class IntLiteral(value: String) extends Token {
  override def toString = value
}
case class Operation(right: Token, op: String, left: Token) extends Token {
  override def toString = s"($right $op $left)"
}
case class ValDecl(name: Variable, initialValue: Token) extends Token {
  override def toString = s"int $name = $initialValue"
}
case class Println(value: Token) extends Token {
  override def toString = s"""printf("%d\\n", $value)"""
}
case class Return(value: Token) extends Token {
  override def toString = s"return $value"
}