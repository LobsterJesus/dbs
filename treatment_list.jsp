<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521:xe"
  user="bic4b16_05"
  password="ohri2Ee"
/>

<sql:query var="list" 
    sql="SELECT TO_CHAR(A.ZEITVON, 'HH24:MI'), A.BEHANDLUNGSTYPID, B.BEHANDLUNGSDAUER, B.ANZAHLDERPERSONEN, B.KOSTEN, C.RAUMBESCHREIBUNG, D.VORNAME, D.NACHNAME
    FROM BEHANDLUNG A INNER JOIN BEHANDLUNGSTYP B
    ON A.BEHANDLUNGSTYPID = B.BEHANDLUNGSTYPID
    LEFT JOIN ORT C
    ON A.RAUMCODE = C.RAUMCODE
    LEFT JOIN PERSON D
    ON A.SVNR = D.SVNR
    WHERE ? IS NULL OR LOWER(A.BEHANDLUNGSTYPID || '|' || C.RAUMBESCHREIBUNG || '|' || D.VORNAME || '|' || D.NACHNAME) LIKE '%' || ? || '%'
    " >
    <sql:param value="${fn:toLowerCase(param.search)}%" />
    <sql:param value="${fn:toLowerCase(param.search)}%" />
</sql:query>

<h2>Liste der Behandlungen</h2>
    
<form class="filter" action="index.jsp" method="get" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
    <label for="search">Suche</label>
    <input type="text" name="search" size="15"/>
    <input type="hidden" name="menu" value="treatment_list"/>
    <input type="submit" value="Suchen">
</form>

<table class="list">
    <tr>
        <th>Zeit</th>
        <th>Dauer</th>
        <th>Personen</th>
        <th>Kosten</th>
        <th>Raum</th>
        <th>Sachbearbeiter</th>
    </tr>
    <c:forEach var="tabRow" begin="0" items="${list.rowsByIndex}">
        <tr>
            <td>${tabRow[0]} Uhr</td>
            <td>${tabRow[2]} Minuten</td>
            <td>${tabRow[3]}</td>
            <td>${tabRow[4]},-</td>
            <td>${tabRow[5]}</td>
            <td>${tabRow[6]} ${tabRow[7]}</td>
        </tr>
    </c:forEach>
</table>

