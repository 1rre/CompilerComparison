
object Main extends App {
  val str = (
    "object Main extends App {\n" ++
    "  val y = (5 + 3) * 5;\n" ++
    "  val x = 10;\n" ++
    "  println(x + y);\n" ++
    "  return x + y * 2;\n" ++
    "}"
  )
  val input = new util.parsing.input.CharSequenceReader(str)
  val read = compiler.Parser.program(input).get
  val cStatements = read.map(" "*2 + _.toString + ";\n").mkString
  println(s"int main() {\n$cStatements}\n")
}