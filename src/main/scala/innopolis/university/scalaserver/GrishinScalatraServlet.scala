package innopolis.university.scalaserver

import org.scalatra._
import scala.collection.mutable.HashMap
import org.json4s._
import org.scalatra.json._

case class Message(id: String, text: String)

class GrishinScalatraServlet extends ScalatraServlet with MethodOverride with JacksonJsonSupport {

    val messages = HashMap.empty[String,Message]
    
    before() {
        contentType = formats("json")
    }
    
    get("/") {
        messages
    }
  
    post("/messages/") {
        try {
            val msg = parsedBody.extract[Message]
            if (!(messages contains msg.id)) {
                messages(msg.id) = msg
                Ok()
            }
            else {
                NotFound()
            }
        }
        catch {
            case e: Exception => NotFound("Wrong JSON")
        }
    }
  
    get("/messages/?") {
        messages
    }
  
    get("/messages/:id/?") {
        val id = params("id")
        if (!(messages contains id))
            NotFound()
        else
            messages(id)
    }

    put("/messages/:id/?") {
        val id = params("id")
        if (!(messages contains id)) {
            NotFound()
        }
        else {
            try {
                val txt = parsedBody \ "text" \\ classOf[JString]
                messages(id) = Message(id, txt(0))
                Ok()
            }
            catch {
                case e: Exception => NotFound()
            }
        }
    }

    delete("/messages/:id/?") {
        val id = params("id")
        if (!(messages contains id)) {
            NotFound()
        }
        else {
            messages -= id
            Ok()
        }
    }
  
    notFound {
        "Sorry"
    }
    
    protected implicit val jsonFormats: Formats = DefaultFormats

}
