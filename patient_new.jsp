<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<fmt:requestEncoding value="UTF-8" />

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521:xe"
  user="bic4b16_05"
  password="ohri2Ee"
/>

<c:if test="${!empty param.create}">
    <c:choose>
        <c:when test="${(empty param.svnr) 
              or (empty param.firstname)
              or (empty param.lastname)
              or (empty param.zip)
              or (empty param.city)
              or (empty param.address)
              or (empty param.number)}">
            <div class="statbar err">
                Bitte füllen Sie alle Felder aus.
            </div>
        </c:when>
        <c:otherwise>
            <c:catch var ="sqlException">
                <sql:update var="count" 
                    sql="INSERT INTO PERSON
                    (SVNR, VORNAME, NACHNAME, PLZ, ORT, STRASSE, HAUSNR)
                    VALUES
                    (?, ?, ?, ?, ?, ?, ?)" >
                    <sql:param value="${param.svnr}" />
                    <sql:param value="${param.firstname}" />
                    <sql:param value="${param.lastname}" />
                    <sql:param value="${param.zip}" />
                    <sql:param value="${param.city}" />
                    <sql:param value="${param.address}" />
                    <sql:param value="${param.number}" />
                </sql:update>
                <sql:update var="count2" 
                    sql="INSERT INTO PATIENT
                    (SVNR, PATNR)
                    VALUES
                    (?, ?)" >
                    <sql:param value="${param.svnr}" />
                    <sql:param value="${param.patnr}" />
                </sql:update>
                <div class="statbar ok">
                    Person wurde gespeichert (<a href="index.jsp?menu=patient_list" target="_top">zur Liste</a>)
                </div>
            </c:catch>
            <c:if test = "${sqlException != null}">
                <div class="statbar err">
                    Fehler: ${sqlException.message}
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</c:if>

<h2>Neuen Patienten anlegen</h2>
    
<form class="newrecord" action="index.jsp?menu=patient_new&create=1" method="post" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
    <div class="row">
        <label for="svnr">Sv.-Nr.</label>
        <input type="text" name="svnr" size="15" required/>
    </div>
    <div class="row">
        <label for="patnr">Pat.-Nr.</label>
        <input type="text" name="patnr" size="15" required/>
    </div>
    <div class="row">
        <label for="firstname">Vorname</label>
        <input type="text" name="firstname" size="15" required/>
    </div>
    <div class="row">
        <label for="lastname">Nachname</label>
        <input type="text" name="lastname" size="15" required/>
    </div>
    <div class="row">
        <label for="zip">PLZ</label>
        <input type="text" name="zip" size="15" required/>
    </div>
    <div class="row">
        <label for="city">Ort</label>
        <input type="text" name="city" size="15" required/>
    </div>
    <div class="row">
        <label for="address">Straße</label>
        <input type="text" name="address" size="15" required/>
    </div>
    <div class="row">
        <label for="number">Hausnummer</label>
        <input type="text" name="number" size="15" required/>
    </div>
    
    <input type="hidden" name="menu" value="patient_new"/>
    
    <div class="row button">
        <input type="submit" value="Anlegen">
    </div>
</form>
