package innopolis.university.scalaserver

import org.scalatra.test.scalatest._

class GrishinScalatraServletTests extends ScalatraFunSuite {

  addServlet(classOf[GrishinScalatraServlet], "/*")

  test("GET / on GrishinScalatraServlet should return status 200"){
    get("/"){
      status should equal (200)
    }
  }

}
