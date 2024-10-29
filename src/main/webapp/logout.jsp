<%@ page session="true" %>
<%@ include file="nav.jsp" %>

<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
