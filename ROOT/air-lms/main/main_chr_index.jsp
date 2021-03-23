<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>    
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	String apr_no			= StringUtil.convertNull(request.getParameter("APR_NO"));
	String view_doc_mas_uid			= StringUtil.convertNull(request.getParameter("VIEW_DOC_MAS_UID"));
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
// 	SQLResults gyCntResult 		= resultMap.getResult("GY_CNTS");
// 	SQLResults jmCntResult 		= resultMap.getResult("JM_CNTS");
// 	SQLResults ssCntResult 		= resultMap.getResult("SS_CNTS");

	SQLResults LMS_MAS 		= resultMap.getResult("LMS_MAS");

	//JD_CNT, JH_CNT,WR_CNT 
	//JH_CNT, WR_CNT
	
	String 접수	= StringUtil.getLocaleWord("L.접수",siteLocale);
	String 대기	= StringUtil.getLocaleWord("L.대기",siteLocale);
	String 진행	= StringUtil.getLocaleWord("L.업무현황_진행",siteLocale);
	String 종결	= StringUtil.getLocaleWord("L.업무현황_종결",siteLocale);
	String 계류	= StringUtil.getLocaleWord("L.업무현황_계류",siteLocale);
	String 건		= StringUtil.getLocaleWord("L.업무현황_건",siteLocale);
	
// 	String gyStatus = 접수대기 + " : " + gyCntResult.getString(0, "JD_CNT")+건+", " + 진행 + " : " + gyCntResult.getString(0, "JH_CNT")+건+ ", " + 종결 + " : " + gyCntResult.getString(0, "WR_CNT")+건;
// 	String jmStatus = 접수대기 + " : " + jmCntResult.getString(0, "JD_CNT")+건 + ", " + 진행 + " : " + jmCntResult.getString(0, "JH_CNT")+건+ ", " + 종결 + " : " + jmCntResult.getString(0, "WR_CNT")+건;
// 	String ssStatus = 계류 + " : " + ssCntResult.getString(0, "JH_CNT")+건+ ", " + 종결 + " : " + ssCntResult.getString(0, "WR_CNT")+건;
	
	String tab1 = "<table class=''>";
	String thisYear = DateUtil.getCurrentYear();

	String jsonDataUrl = "/ServletController"
	        + "?AIR_ACTION=LMS_MAIN"
	        + "&AIR_MODE=JSON_BAEDANG_STAT"
	        + "&GUBUN="+ "";
 %>
<script>
/**
 * 결재할 건이 있을시 결재창 팝업
 */
 var initGyeolPop = function(){
	
	//결재창팝업
	main.initGyeolPop(function(data){
		if(data.total > 0){
			var obj = $("a[data-id='apr']");
			clickNm(obj);
			getAprvLJSON(1);
//			결재 존재시 결재자동팝업 에서 결재탭열기로 변경
// 			if(airCommon.getCookie("toDate") != "GyealOk"){
// 				main.MainGyeol_View();
// 			}
		}
	}); 
 }

$(window).load(function(){
	airCommon.hideBackDrop();
});

/**
 * 일정 바로가기
 */
function menuQuick_openScdl() {
	airCommon.popupScdlList("", "", "");
}

/**
 * 결재문서함 바로가기
 */
function menuQuick_openGyeol() {
    airCommon.openWindow('/ServletController?AIR_ACTION=SYS_APR&AIR_MODE=POPUP_APR_LIST', 1024, 490, '결재문서', 'yes', 'yes');
}

/**
 * 통계 바로가기
 */
function menuQuick_openStats() {
	airCommon.openWindow('/ServletController?AIR_ACTION=LMS_TG&AIR_MODE=POPUP_INDEX', 1024, 680, 'winStatsPopUp', 'yes', 'yes');
}

var initMain = function(){
	var pageNo =1;
	var data = {};
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("LMS_MAIN", "CHR_ALL_DATA",data, function(json){
		//-- 각종 상태 카운트 적용
		var procStat = json.PROC_STAT
		$.each(procStat[0], function(k, v){
			$("#"+k.toLowerCase()).text(v);
		});
		
		var id = $(".list_title_b").eq(0).data("id");
		if(id == "to_do"){
			//-- TODO리스트 적용
			airCommon.createTableRow("LmsChrToDoTable", JSON.parse(json.TODO_LIST), pageNo, 10, "getToDoJSON");
		}else if(id == "rec"){
			//-- 접수대기리스트 적용
			airCommon.createTableRow("LmsChrToDoTable", JSON.parse(json.RECEIVE_LIST), pageNo, 10, "getReceiveJSON");
		}else if(id == "apr"){
			//-- 결재정보 적용
			airCommon.createTableRow("LmsChrToDoTable", JSON.parse(json.APR_LIST), pageNo, 10, "getAprvLJSON");
		}
		
	});
	
<%-- 	<%if (loginUser.isUserAuth("LMS_BCD")) { %>	 --%>
// 	runStat();
<%-- 	<%}%>	 --%>
	
};

$(function(){
	airCommon.showBackDrop();
	
	initMain();
	//결재창팝업
	initGyeolPop(); 
	
	<%if(LMS_MAS != null && LMS_MAS.getRowCount() > 0){%>
		<%if(StringUtil.isNotBlank(apr_no)){%>
		
		    var url = "/ServletController";
		    url += "?AIR_ACTION=SYS_APR_TEP";  
		   	url += "&AIR_MODE=INDEX";  
		   	url += "&apr_no=<%=apr_no%>";  
		   	url += "&sol_mas_uid=<%=LMS_MAS.getString(0, "SOL_MAS_UID")%>";  
		   	url += "&view_doc_mas_uid=<%=view_doc_mas_uid%>";  
		    airCommon.openWindow(url, "1024", "700", "TEP_<%=LMS_MAS.getString(0, "SOL_MAS_UID")%>", "yes", "yes"); 
		<%}else{%>
		airLms.goGwanRyeonPopup('<%=LMS_MAS.getString(0, "STU_GBN")%>','<%=LMS_MAS.getString(0, "SOL_MAS_UID")%>');
		<%}%>
	<%}%>
});
</script>
<%-- <jsp:include page='/air-lms/_include/menu.quick.jsp' flush='true' /> --%>
<!--containe 시작-->
	<div class="total">
		<div class="total_area">
			<ul>
				<li class="box active">
					<p><%=StringUtil.getLocaleWord("L.계약", siteLocale) %></p>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.접수대기", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&STAT_CD=<%=LmsConstants.준비 %>');" id="gy_jd_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토진행", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.진행 %>');"  id="gy_jh_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토완료", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.검토완료 %>');"  id="gy_wr_cnt"></a>
					</div>
				</li>
				<li class="box">
					<p><%=StringUtil.getLocaleWord("L.자문", siteLocale) %></p>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.접수대기", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&STAT_CD=<%=LmsConstants.준비 %>');" id="jm_jd_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토진행", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.진행 %>');"  id="jm_jh_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토완료", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.검토완료 %>');"  id="jm_wr_cnt"></a>
					</div>
				</li>
				<li class="box">
					<p><%=StringUtil.getLocaleWord("L.소송", siteLocale) %></p>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.진행", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_SS_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.진행 %>')" id="ss_jh_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.확정", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_SS_LIST','&damdang_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.검토완료 %>')" id="ss_wr_cnt"></a>
					</div>
				</li>
			</ul>
			<div class="calendar">
				<iframe name="mainScdlFrame" id="mainScdlFrame" src="/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=SELECT" frameborder="0" scrolling="no" style="width:253px;height:220px;"></iframe>
			</div>
			<div class="quick_menu">
				<p>QUICK MENU</p>
				<a href="javascript:void(0)" onclick="menuQuick_openGyeol()"><img src="air-lms/_images/img_quick01.png"> <%=StringUtil.getLocaleWord("L.결재문서함", siteLocale) %></a>
				<a href="javascript:void(0)" onclick="menuQuick_openScdl()"><img src="air-lms/_images/img_quick02.png"> <%=StringUtil.getLocaleWord("L.일정", siteLocale) %></a>
				<a href="javascript:void(0)" onclick="airLms.popupLegalTeamManualDownload('<%= loginUser.gethoesaCod()%>')"><img src="air-lms/_images/img_quick03.png"> <%=StringUtil.getLocaleWord("L.법무팀매뉴얼", siteLocale) %></a>
				<a href="javascript:void(0)" onclick="airLms.popupUserManualDownload('<%= loginUser.gethoesaCod()%>')"><img src="air-lms/_images/img_quick03.png"> <%=StringUtil.getLocaleWord("L.현업팀매뉴얼", siteLocale) %></a>
			</div>
		</div>
	</div>
	<div class="contents">
<%-- 
<%if (loginUser.isUserAuth("LMS_BCD")) { %>
		<div class="board_cover">
			<div class="f_left">
				<p class="list_title">업무현황</p>

				<table class="list" id="LmsTaskStatusTable">
					<colgroup>
						<col style="width:auto;" />
						<col style="width:13%;" />
						<col style="width:13%;" />
						<col style="width:13%;" />
						<col style="width:13%;" />
						<col style="width:13%;" />
						<col style="width:13%;" />
					</colgroup>
					<thead>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.담당자", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.계약_진행", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.계약_완료", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.자문_진행", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.자문_완료", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.소송_진행", siteLocale) %></th>
						<th><%=StringUtil.getLocaleWord("L.소송_완료", siteLocale) %></th>
					</tr>
					</thead>
					<tbody id="damdangBody"></tbody>
				</table>
			</div>
		</div>
<% } %>
 --%>
		<div class="board_cover">
			<div class="f_left">
				<p class="list_title">
					<a onClick="getToDoJSON(1);clickNm(this);" class="list_title_b" data-type='list_title' data-id="to_do"><%=StringUtil.getLocaleWord("L.TO_DO", siteLocale) %></a>
					<span style="font-weight:100; font-size:20px; color:#AAAAAA;" >&nbsp;|&nbsp;</span>
					<a onClick="getReceiveJSON(1);clickNm(this);" class="list_title_a" data-type='list_title' data-id="rec"><%=StringUtil.getLocaleWord("L.접수대기", siteLocale) %></a>
					<span style="font-weight:100; font-size:20px; color:#AAAAAA;">&nbsp;|&nbsp;</span>
					<a onClick="getAprvLJSON(1); clickNm(this);" class="list_title_a" data-type="list_title" data-id="apr"><%=StringUtil.getLocaleWord("L.결재진행", siteLocale) %></a>
				</p>

				<table class="list" id="LmsChrToDoTable">
					<thead>
					<tr data-opt='{"onClick":"main.goPopupIndex(\"@{STU_GBN}\",\"@{SOL_MAS_UID}\",\"@{GB_DOC_MAS_UID}\",\"@{APR_NO}\")"}'>
						<th style="width:40px" data-opt='{"align":"center","col":"GBN_NAM"}'><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
						<th style="width:100px" data-opt='{"align":"center","col":"GWANRI_NO"}'><%=StringUtil.getLocaleWord("L.관리번호", siteLocale) %></th>
						<th style="width:140px" data-opt='{"align":"center","col":"HOESA_NAM"}'><%=StringUtil.getLocaleWord("L.회사", siteLocale) %></th>
						<th style="width:150px" data-opt='{"align":"center","col":"YOCHEONG_NAM"}'><%=StringUtil.getLocaleWord("L.요청자", siteLocale) %></th>
						<th style="width:auto" data-opt='{"align":"center","col":"TITLE"}'><%=StringUtil.getLocaleWord("L.건명", siteLocale) %></th>
<%-- 						<th style="width:40px" data-opt='{"align":"center","col":"EONEO_NAM"}'><%=StringUtil.getLocaleWord("L.언어", siteLocale) %></th> --%>
						<th style="width:140px" data-opt='{"align":"center","col":"STU_NAM"}'><%=StringUtil.getLocaleWord("L.진행상태", siteLocale) %></th>
						<th style="width:85px" data-opt='{"align":"center","col":"YOCHEONG_DTE"}'><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
					</tr>
					</thead>
					<tbody id="LmsChrToDoTableBody"></tbody>
				</table>
				<%-- 페이지 목록 --%>
				<div class="pagelist" id="LmsChrToDoTablePage"></div> 
				
				<script>
				var clickNm = function(obj){
					$("a[data-type='list_title']").attr('class','list_title_a');
					$(obj).attr('class','list_title_b');
				}
				//-- TODO list
				var getToDoJSON = function(pageNo){
					if(pageNo == undefined) pageNo =1;
					var data = {};
					data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
					data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
					
					airCommon.callAjax("LMS_MAIN", "CHR_TO_DO_JSON",data, function(json){
						
						airCommon.createTableRow("LmsChrToDoTable", json, pageNo, 10, "getToDoJSON");
					});
				};
				//-- Receive list
				var getReceiveJSON = function(pageNo){
					if(pageNo == undefined) pageNo =1;
					var data = {};
					data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
					data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
					
					airCommon.callAjax("LMS_MAIN", "CHR_RECEIVE_JSON",data, function(json){
						
						airCommon.createTableRow("LmsChrToDoTable", json, pageNo, 10, "getReceiveJSON");
					});
				};
				//-- 결재목록
				var getAprvLJSON = function(pageNo){
					if(pageNo == undefined) pageNo =1;
					var data = {};
					data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
					data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
					
					airCommon.callAjax("LMS_MAIN", "APRV_JSON",data, function(json){
						
						airCommon.createTableRow("LmsChrToDoTable", json, pageNo, 10, "getAprvLJSON");
					});
				};
				</script>

			</div>
		</div>
	</div>
<%-- 
<%if (loginUser.isUserAuth("LMS_BCD")) { %>	
 <script>
 	var runStat = function(){
 		$.ajax({
			url: "<%=jsonDataUrl%>"
			, type: "POST"
			, async: true
			, cache: false
		}).done(function(data){
			$("#damdangBody").html("");
			$("#damdangListTmpl").tmpl(data).appendTo($("#damdangBody"));
			//-- 합계 데이터 생성
			if($("#damdangBody").find('tr').length > 0){
				var arrSumDt = [0,0,0,0,0,0];
				
				$("#damdangBody").find('tr').each(function(i, tr){
					var trI = $(tr).find("td").each(function(j, td){
						if(j > 0){
							arrSumDt[j-1] += parseInt($(td).text());
						}
					});
				});
				
				var oTr = $("<tr>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>합계</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[0]+"</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[1]+"</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[2]+"</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[3]+"</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[4]+"</td>");
				oTr.append("<td style='text-align:center;font-weight:bold;'>"+arrSumDt[5]+"</td>");
				
				$("#damdangBody").append(oTr);
			}
			
			
		});
 	}
</script>
<script id="damdangListTmpl" type="text/html">
    <tr id="\${UUID}">
  		<td style="text-align:center;">\${NAME_<%=siteLocale%>}</td>
		<td style="text-align:center;">\${GY_JH_CNT}</td>
		<td style="text-align:center;">\${GY_WR_CNT}</td>
		<td style="text-align:center;">\${JM_JH_CNT}</td>
		<td style="text-align:center;">\${JM_WR_CNT}</td>
		<td style="text-align:center;">\${SS_JH_CNT}</td>
		<td style="text-align:center;">\${SS_WR_CNT}</td>
	</tr>
</script>
<% } %>	 
 --%>