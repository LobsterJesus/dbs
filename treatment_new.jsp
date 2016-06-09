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
    <c:catch var ="sqlException">
        <sql:update var="count" 
            sql="INSERT INTO BEHANDLUNG
            (BEHANDLUNGSTYPID, ZEITVON, RAUMCODE, SVNR)
            VALUES
            (?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?)" >
            <sql:param value="${param.type}" />
            <sql:param value="${param.time}" />
            <sql:param value="${param.room}" />
            <sql:param value="${param.person}" />
        </sql:update>
        <div class="statbar ok">
            Person wurde gespeichert (<a href="index.jsp?menu=treatment_list" target="_top">zur Liste</a>)
        </div>
    </c:catch>
    <c:if test = "${sqlException != null}">
        <div class="statbar err">
            Fehler: ${sqlException.message}
        </div>
    </c:if>
</c:if>

<c:if test="${!empty param.createAppointment}">
    <sql:update var="count" 
        sql="INSERT INTO VORMERKUNG
        (BEHANDLUNGSTYPID, ZEITVON, RAUMCODE, SVNR_PATIENT, SVNR_ARZT, DATUM)
        VALUES
        (?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, ?, TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'))" >
        <sql:param value="${param.type}" />
        <sql:param value="${param.time}" />
        <sql:param value="${param.room}" />
        <sql:param value="${param.patient}" />
        <sql:param value="${param.doctor}" />
        <sql:param value="${param.appDate}" />
    </sql:update>
</c:if>

<sql:query var="type" sql="SELECT BEHANDLUNGSTYPID FROM BEHANDLUNGSTYP" >
</sql:query>

<sql:query var="room" sql="SELECT RAUMCODE, RAUMBESCHREIBUNG FROM ORT" >
</sql:query>

<sql:query var="person" 
    sql="SELECT A.SVNR, B.VORNAME, B.NACHNAME
FROM SACHBEARBEITER A INNER JOIN PERSON B
ON A.SVNR= B.SVNR" >
</sql:query>

<sql:query var="patient" 
    sql="SELECT B.SVNR, B.VORNAME, B.NACHNAME
FROM PATIENT A INNER JOIN PERSON B
ON A.SVNR = B.SVNR" >
</sql:query>

<sql:query var="doctor" 
    sql="SELECT B.SVNR, B.VORNAME, B.NACHNAME
FROM ARZT A INNER JOIN PERSON B
ON A.SVNR = B.SVNR" >
</sql:query>

<h2>Neue Behandlung anlegen</h2>
    
<form class="newrecord" action="index.jsp?menu=treatment_new&create=1" method="post" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
    <div class="row">
        <label for="type">Typ</label>
        <select name="type">
            <c:forEach var="tabRow" begin="0" items="${type.rowsByIndex}">
                <option value="${tabRow[0]}">${tabRow[0]}</option>
            </c:forEach>
        </select>
    </div>
    <div class="row">
        <label for="room">Raum</label>
        <select name="room">
            <c:forEach var="tabRow" begin="0" items="${room.rowsByIndex}">
                <option value="${tabRow[0]}">${tabRow[1]}</option>
            </c:forEach>
        </select>
    </div>
    <div class="row">
        <label for="person">Sachbearbeiter</label>
        <select name="person">
            <c:forEach var="tabRow" begin="0" items="${person.rowsByIndex}">
                <option value="${tabRow[0]}">${tabRow[1]} ${tabRow[2]}</option>
            </c:forEach>
        </select>
    </div>
    <div class="row">
        <label for="time">Zeit</label>
        <select name="time">
            <option value="2016-12-12 09:00:00">09:00</option>
            <option value="2016-12-12 09:30:00">09:30</option>
            <option value="2016-12-12 10:00:00">10:00</option>
            <option value="2016-12-12 10:30:00">10:30</option>
            <option value="2016-12-12 11:00:00">11:00</option>
            <option value="2016-12-12 11:30:00">11:30</option>
            <option value="2016-12-12 12:00:00">12:00</option>
            <option value="2016-12-12 12:30:00">12:30</option>
            <option value="2016-12-12 13:00:00">13:00</option>
            <option value="2016-12-12 13:30:00">13:30</option>
        </select>
    </div>
    <br/>
    <div class="row">
        <input 
            type="checkbox" 
            style="width: auto; float: none;" 
            name="createAppointment" 
            value="1"
            onclick="document.getElementById('appointment').style.display = (this.checked ? 'block' : 'none');"> Vormerkung für Patient erstellen<br>
    </div>
    <div id="appointment" style="display: none;">
        <div class="row">
            <label for="patient">Patient</label>
             <select name="patient">
                <c:forEach var="tabRow" begin="0" items="${patient.rowsByIndex}">
                    <option value="${tabRow[0]}">${tabRow[1]} ${tabRow[2]}</option>
                </c:forEach>
            </select>
        </div>
        <div class="row">
            <label for="doctor">Arzt</label>
             <select name="doctor">
                <c:forEach var="tabRow" begin="0" items="${doctor.rowsByIndex}">
                    <option value="${tabRow[0]}">Dr. ${tabRow[1]} ${tabRow[2]}</option>
                </c:forEach>
            </select>
        </div>
        <div class="row">
            <label for="appDate">Datum</label>
            <select name="appDate">
                <option value="2016-12-01 00:00:00">01.12.2016</option>
                <option value="2016-12-02 09:30:00">02.12.2016</option>
                <option value="2016-12-03 10:00:00">03.12.2016</option>
                <option value="2016-12-04 10:30:00">04.12.2016</option>
                <option value="2016-12-05 11:00:00">05.12.2016</option>
                <option value="2016-12-06 11:30:00">06.12.2016</option>
                <option value="2016-12-07 12:00:00">07.12.2016</option>
            </select>
        </div>
    </div>
    
    <div class="row button">
        <input type="submit" value="Anlegen">
    </div>
</form>
