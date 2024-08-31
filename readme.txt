Devops eğitim dokümanlarının takibini bu repo ile yapacağız.
Basit bir Servlet Oluşturma: HelloServlet.java adında bir servlet oluşturalım. Bu servlet, tarayıcıdan gelen istekleri karşılayıp bir mesaj dönecek.

java
Copy code
package com.example.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<h1>Merhaba, Dünya!</h1>");
    }
}
