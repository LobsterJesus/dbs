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
    sql="SELECT DISTINCT B.SVNR, A.PATNR, B.VORNAME, B.NACHNAME, B.PLZ, B.ORT, B.STRASSE, B.HAUSNR,
    TO_CHAR(C.ZEITVON, 'HH24:MI') AS APPZEITVON, TO_CHAR(C.DATUM, 'DD.MM.YYYY') AS APPDATUM, 
    C.NACHNAME AS APPARZT
    FROM PATIENT A INNER JOIN PERSON B
    ON A.SVNR = B.SVNR
    LEFT JOIN (
    SELECT X.SVNR_PATIENT, X.ZEITVON, X.DATUM, Y.NACHNAME
    FROM VORMERKUNG X INNER JOIN PERSON Y
    ON X.SVNR_ARZT = Y.SVNR
    ) C ON C.SVNR_PATIENT = A.SVNR
    WHERE ? IS NULL OR LOWER(B.SVNR || '|' || A.PATNR || '|' || B.VORNAME || '|' || B.NACHNAME || 
    '|' || B.PLZ || '|' || B.ORT || '|' || B.STRASSE) LIKE '%' || ? || '%'
    ORDER BY B.NACHNAME" >
    <sql:param value="${fn:toLowerCase(param.search)}%" />
    <sql:param value="${fn:toLowerCase(param.search)}%" />
</sql:query>

<h2>Patientenliste</h2>
    
<form class="filter" action="index.jsp" method="get" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
    <label for="search">Suche</label>
    <input type="text" name="search" size="15"/>
    <input type="hidden" name="menu" value="patient_list"/>
    <input type="submit" value="Suchen">
</form>

<table class="list">
    <tr>
        <th>Sv.-Nr.</th>
        <th>Pat.-Nr.</th>
        <th>Nachname</th>
        <th>Vorname</th>
        <th>PLZ</th>
        <th>Ort</th>
        <th>Straﬂe</th>
        <th>Haus-Nr.</th>
        <th>Vormerkung</th>
    </tr>
    <c:forEach var="tabRow" begin="0" items="${list.rowsByIndex}">
        <tr>
            <td>${tabRow[0]}</td>
            <td>${tabRow[1]}</td>
            <td>${tabRow[3]}</td>
            <td>${tabRow[2]}</td>
            <td>${tabRow[4]}</td>
            <td>${tabRow[5]}</td>
            <td>${tabRow[6]}</td>
            <td>${tabRow[7]}</td>
            <td style="font-size: 11px">
                <c:if test="${!empty tabRow[9]}">
                    ${tabRow[9]}, ${tabRow[8]} Uhr bei Dr. ${tabRow[10]}
                </c:if>
                <c:if test="${empty tabRow[9]}">
                    <a href="index.jsp?menu=appointment_new&step=1&patient=${tabRow[0]}" target="_top">Vormerkung anlegen</a>
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>

