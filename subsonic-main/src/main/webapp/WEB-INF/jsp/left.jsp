<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>
<%@ include file="/include.jsp" %>

<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="/subsonic/style.css" rel="stylesheet">
</head>
<body style="background-color:#DEE3E7">

<p style="font-size:8pt; white-space:nowrap"><em>
    <c:if test="${model.statistics != null}">
        <fmt:message key="left.statistics">
            <fmt:param value="${model.statistics.artistCount}"/>
            <fmt:param value="${model.statistics.albumCount}"/>
            <fmt:param value="${model.statistics.songCount}"/>
            <fmt:param value="${model.bytes}"/>
            <fmt:param value="${model.hours}"/>
        </fmt:message>
    </c:if>
</em></p>

<c:if test="${not empty model.musicFolders}">
    <select name="musicFolderId" style="width:100%" onchange="location='left.view?musicFolderId=' + options[selectedIndex].value;" >
        <option value="-1"><fmt:message key="left.allfolders"/></option>
        <c:forEach items="${model.musicFolders}" var="musicFolder">
            <option <c:if test="${model.selectedMusicFolder == musicFolder}">selected</c:if> value="<c:out value="${musicFolder.id}"/>"><c:out value="${musicFolder.name}"/></option>
        </c:forEach>
    </select>
</c:if>

<c:if test="${not empty model.radios}">
    <h2><fmt:message key="left.radio"/></h2>
    <c:forEach items="${model.radios}" var="radio">
        <p class="dense">
            <a target="hidden" href="playRadio.jsp?id=<c:out value="${radio.id}"/>">
                <img width="13" height="13" src="icons/play.gif" alt="<fmt:message key="common.play"/>" title="<fmt:message key="common.play"/>"/></a>
            <c:choose>
                <c:when test="${empty radio.homepageUrl}">
                    <c:out value="${radio.name}"/>
                </c:when>
                <c:otherwise>
                    <a target="main" href="<c:out value="${radio.homepageUrl}"/>"><c:out value="${radio.name}"/></a>
                </c:otherwise>
            </c:choose>
        </p>
    </c:forEach>
</c:if>

<c:forEach items="${model.indexedChildren}" var="entry">
    <a name="<c:out value="${entry.key.index}"/>"/>
    <h2><c:out value="${entry.key.index}"/></h2>

    <c:forEach items="${entry.value}" var="child">
        <c:url value="playlist.jsp" var="playUrl">
            <c:param name="play" value="${child.path}"/>
        </c:url>
        <c:url value="playlist.jsp" var="addUrl">
            <c:param name="add" value="${child.path}"/>
        </c:url>

        <p class="dense">
            <a target="playlist" href="<c:out value="${playUrl}"/>">
                <img width="13" height="13" src="icons/play.gif" alt="<fmt:message key="common.play"/>" title="<fmt:message key="common.play"/>"/></a>
            <a target="playlist" href="<c:out value="${addUrl}"/>">
                <img width="13" height="13" src="icons/add.gif" alt="<fmt:message key="common.add"/>" title="<fmt:message key="common.add"/>"/></a>
            <c:if test="${model.downloadEnabled}">
                <c:url value="download" var="downloadUrl">
                    <c:param name="path" value="${child.path}"/>
                </c:url>
                <a href="<c:out value="${downloadUrl}"/>">
                    <img width="13" height="13" src="icons/download.gif" alt="<fmt:message key="common.download"/>" title="<fmt:message key="common.download"/>"/></a>
            </c:if>

            <c:choose>
                <c:when test="${child.directory}">
                    <c:url value="main.jsp" var="mainUrl">
                        <c:param name="path" value="${child.path}"/>
                    </c:url>
                    <a target="main" href="<c:out value="${mainUrl}"/>"><c:out value="${child.name}"></c:out></a>
                </c:when>
                <c:otherwise>
                    <c:out value="${child.name}"></c:out>
                </c:otherwise>
            </c:choose>
        </p>
    </c:forEach>
</c:forEach>

</body></html>