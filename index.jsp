<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="de" lang="de">
	<head>
		<title>Spitalverwaltung</title>
                <link rel="stylesheet" type="text/css" href="styles.css">
	</head>
	<body>
            <h1>Spitalverwaltung</h1>
            <%@ include file="menu.jsp" %>
            <div class="content">
                <c:if test="${!empty param.menu}">
                    <jsp:include page="${param.menu}.jsp" />
                </c:if>
                <c:if test="${empty param.menu}">
                    <jsp:include page="init.jsp" />
                </c:if>
            </div>
	</body>
</html>
