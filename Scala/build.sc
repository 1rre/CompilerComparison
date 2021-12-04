import mill._, scalalib._

object Scala2C extends ScalaModule {
  def ivyDeps = Agg(ivy"org.scala-lang.modules::scala-parser-combinators:2.1.0")
  def scalaVersion = "2.13.7"
}