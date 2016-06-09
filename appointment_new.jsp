<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 

<fmt:requestEncoding value="UTF-8" />

<sql:setDataSource
  driver="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@localhost:1521:xe"
  user="bic4b16_05"
  password="ohri2Ee"
/>

<c:choose>
    <c:when test="${param.step == '1'}">
        <sql:query var="type" sql="SELECT BEHANDLUNGSTYPID, TO_CHAR(ZEITVON, 'YYYY-MM-DD HH24:MI') ZEITVON, TO_CHAR(ZEITVON, 'HH24:MI') ZEITVON_LABEL FROM BEHANDLUNG" >
        </sql:query>
        
        <h2>Vermerkung anlegen</h2>
        <h3>Schritt 1: Behandlung wählen</h3>
        <fmt:setLocale value="en_US" />
        <form class="newrecord" action="index.jsp?menu=appointment_new&step=2" method="post" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
            <div class="row">
                <label for="type">Behandlung</label>
                <select name="type">
                    <c:forEach var="tabRow" begin="0" items="${type.rowsByIndex}">
                        <option value="${tabRow[0]},${tabRow[1]}:00">${tabRow[0]} (${tabRow[2]})</option>
                    </c:forEach>
                </select>
            </div>
            <div class="row button">
                <input type="submit" value="Weiter">
            </div>
            <input type="hidden" name="patient" value="${param.patient}">
        </form>
        
    </c:when>
    <c:when test="${param.step == '2'}">

        <sql:query var="doctor" 
            sql="SELECT B.SVNR, B.VORNAME, B.NACHNAME
        FROM ARZT A INNER JOIN PERSON B
        ON A.SVNR = B.SVNR" >
        </sql:query>
        
        <h2>Vermerkung anlegen</h2>
        <h3>Schritt 2: Arzt wählen</h3>
        
        <form class="newrecord" action="index.jsp?menu=appointment_new&step=3" method="post" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
             <div class="row">
                <label for="doctor">Arzt</label>
                 <select name="doctor">
                    <c:forEach var="tabRow" begin="0" items="${doctor.rowsByIndex}">
                        <option value="${tabRow[0]}">Dr. ${tabRow[1]} ${tabRow[2]}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="row button">
                <input type="submit" value="Weiter">
            </div>
            <input type="hidden" name="patient" value="${param.patient}">
            <input type="hidden" name="type" value="${fn:split(param.type, ',')[0]}">
            <input type="hidden" name="time" value="${fn:split(param.type, ',')[1]}">
        </form>
    </c:when>  
    <c:when test="${param.step == '3'}">
        
        <sql:query var="room" sql="SELECT RAUMCODE, RAUMBESCHREIBUNG FROM ORT" >
        </sql:query>
        
        <h2>Vermerkung anlegen</h2>
        <h3>Schritt 3: Raum und Datum wählen</h3>
        
        <form class="newrecord" action="index.jsp?menu=appointment_new&step=create" method="post" target="_top" accept-charset="UTF-8" enctype="application/x-www-form-urlencoded">
            <div class="row">
                <label for="room">Raum</label>
                <select name="room">
                    <c:forEach var="tabRow" begin="0" items="${room.rowsByIndex}">
                        <option value="${tabRow[0]}">${tabRow[1]}</option>
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
            <div class="row button">
                <input type="submit" value="Erstellen">
            </div>
            <input type="hidden" name="patient" value="${param.patient}">
            <input type="hidden" name="type" value="${param.type}">
            <input type="hidden" name="time" value="${param.time}">
            <input type="hidden" name="doctor" value="${param.doctor}">
        </form>
    </c:when>
    <c:when test="${param.step == 'create'}">
        <c:catch var ="sqlException">
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
            <h2>Vermerkung wurde gespeichert</h2>
            <p>Zurück <a href="index.jsp?menu=patient_list" target="_top">zur Patientenliste</a></p>
        </c:catch>
        <c:if test = "${sqlException != null}">
            <h2 style="color: red;">Vermerkung konnte nicht gespeichert werden</h2>
            <p>Fehler: ${sqlException.message}</p>
            <p><a href="javascript:history.back();">Zurück zur Eingabe</a></p>
            <p><a href="index.jsp?menu=patient_list" target="_top">Zurück zur Patientenliste</a></p>
        </c:if>
        
    </c:when>
</c:choose>