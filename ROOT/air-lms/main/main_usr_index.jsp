<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	String apr_no			= StringUtil.convertNull(request.getParameter("APR_NO"));
	String view_doc_mas_uid			= StringUtil.convertNull(request.getParameter("VIEW_DOC_MAS_UID"));
	
	String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
// 	SQLResults gyCntResult = resultMap.getResult("GY_CNTS");
// 	SQLResults jmCntResult = resultMap.getResult("JM_CNTS");
// 	SQLResults ijCntResult = resultMap.getResult("IJ_CNTS");

	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	//JD_CNT, JH_CNT,WR_CNT 

	String 접수대기 = StringUtil.getLocaleWord("L.업무현황_접수대기", siteLocale);
	String 진행 = StringUtil.getLocaleWord("L.업무현황_진행", siteLocale);
	String 종결 = StringUtil.getLocaleWord("L.업무현황_종결", siteLocale);
	String 계류 = StringUtil.getLocaleWord("L.업무현황_계류", siteLocale);
	String 건 = StringUtil.getLocaleWord("L.업무현황_건", siteLocale);
%>
<script>
/**
 * 	2016.06.30
 *	author sitas
 *	함수의 종류가 많고 담당자/유저 메이인 jsp에 중복으로 기술되어 지는 
 *	문제점이 있으므로 공통적인 스크립트들은 js 파일에 담았음
 *  경로  : /air-lms/_js/main.js
 */
 
 	var initMain = function(){
		var pageNo =1;
		var data = {};
		data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
		data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
		
		airCommon.callAjax("LMS_MAIN", "USR_ALL_DATA",data, function(json){
			//-- 각종 상태 카운트 적용
			var procStat = json.PROC_STAT
			$.each(procStat[0], function(k, v){
				$("#"+k.toLowerCase()).text(v);
			});
			
			var id = $(".list_title_b").eq(0).data("id");
			if(id == "to_do"){
				//-- TODO리스트 적용
				airCommon.createTableRow("LmsUsrToDoTable", JSON.parse(json.TODO_LIST), pageNo, 10, "getToDoJSON");
			}else if(id == "apr"){
				airCommon.createTableRow("LmsUsrToDoTable", JSON.parse(json.APR_LIST), pageNo, 10, "getAprvLJSON");
			}
		});
	 
	}
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
//  				결재 존재시 결재자동팝업 에서 결재탭열기로 변경
//  				if(airCommon.getCookie("toDate") != "GyealOk"){
//  					main.MainGyeol_View();
//  				}
 			}
 		}); 
 	 }
	$(function(){
		airCommon.showBackDrop();
		initMain();
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
	
	$(window).load(function(){
		airCommon.hideBackDrop();
	});
</script>
	<div class="total">
		<div class="total_area_usr">
			<ul>
				<li class="box active">
					<p class="long"><%=StringUtil.getLocaleWord("L.계약", siteLocale) %></p>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.접수대기", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId()%>&STAT_CD=<%=LmsConstants.준비 %>');" id="gy_jd_cnt"></a>
					</div>
					<!-- 
					<div class="data">
						<span>법무담당자배정</span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&shJinHaengSangTae=null');"  id="gy_jj_cnt"></a>
					</div>
					 -->
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토진행", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.진행 %>');"  id="gy_jh_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토완료", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.검토완료 %>');"  id="gy_gw_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.계약품의", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.품의진행 %>');"  id="gy_pj_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.계약품의완료", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.품의완료 %>');"  id="gy_pe_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.체결계약서", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_GY_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.체결계약등록 %>');"  id="gy_wr_cnt"></a>
					</div>
				</li>
				<li class="box">
					<p class="long"><%=StringUtil.getLocaleWord("L.자문", siteLocale) %></p>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.접수대기", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.준비 %>');" id="jm_jd_cnt"></a>
					</div>
					<!-- 
					<div class="data">
						<span>법무담당자배정</span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&shJinHaengSangTae=null');"  id="jm_jj_cnt"></a>
					</div> 
					-->
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토진행", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.진행 %>');"  id="jm_jh_cnt"></a>
					</div>
					<div class="data">
						<span><%=StringUtil.getLocaleWord("L.검토완료", siteLocale) %></span>
						<a href="#" onclick="main.goPopUpStat('LMS_MAIN','POPUP_JM_LIST','&yocheong_id=<%=loginUser.getLoginId() %>&STAT_CD=<%=LmsConstants.검토완료 %>');"  id="jm_wr_cnt"></a>
					</div>
				</li>
			</ul>
		</div>
	</div>
	
	<div class="contents">
	
		<div class="direct_block">
			<ul>
				<li>
					<a href="javascript:void(0);" onclick="goMenuPage('SYS_FORM', 'POPUP_WRITE_FORM', '&munseo_seosig_no=DDD-LMS-GY-001&next_stu_id=GY_REQ&stu_id=GY_REQ','POPUP', 'GY')">
						<img src="air-lms/_images/direct01.png" />
						<p><%=StringUtil.getLocaleWord("L.계약검토요청", siteLocale) %></p>
						<div><%=StringUtil.getLocaleWord("M.바로가기_계약검토", siteLocale) %></div>
					</a>
				</li>
				<!-- <li>
					<a href="javascript:void(0);" onclick="main.goDetail('GY','&MENU_NAME_KO=법무검토 완료 계약품의&GEOMTO_YN=Y&STU_ID=GY_RST,GY_RST_RE_RST,GY_PUM_RST');">
						<img src="air-lms/_images/direct02.png" />
						<p>법무검토완료 <br />계약품의</p>
						<div>법무검토완료 계약<br />품의를 진행할 수<br /> 있습니다.</div>
					</a>
				</li> -->
				<li>
<!-- 					<a href="javascript:void(0);" onclick="goMenuPage('SYS_FORM', 'POPUP_WRITE_FORM', '&munseo_seosig_no=DDD-LMS-GY-014&next_stu_id=GY_PUM2&stu_id=GY_PUM2','POPUP', 'GY')"> -->
					<a href="javascript:void(0);" onclick="goMenuPage('SYS_FORM', 'POPUP_WRITE_FORM', '&munseo_seosig_no=DDD-LMS-GY-014&next_stu_id=GY_PUM2&stu_id=GY_PUM2','POPUP', 'GY')">
						<img src="air-lms/_images/direct02.png" />
						<p><%=StringUtil.getLocaleWord("L.법무검토생략_계약", siteLocale) %></p>
						<div><%=StringUtil.getLocaleWord("M.바로가기_계약검토생략", siteLocale) %></div>
					</a>
				</li>
				<li>
					<a href="javascript:void(0);" onclick="goMenuPage('SYS_FORM', 'POPUP_WRITE_FORM', '&munseo_seosig_no=DDD-LMS-JM-001&next_stu_id=JM_REQ&stu_id=JM_REQ','POPUP', 'JM')">
						<img src="air-lms/_images/direct03.png" />
						<p><%=StringUtil.getLocaleWord("L.법률자문의뢰", siteLocale) %></p>
						<div><%=StringUtil.getLocaleWord("M.바로가기_법률자문", siteLocale) %></div>
					</a>
				</li>
				<!-- <li>
					<a href="javascript:void(0);" onclick="main.goDetail('IJ');">
						<img src="air-lms/_images/direct04.png" />
						<p>법인인감</p>
						<div>계약서 등에 대한 <br />법인인감 날인을 <br />신청할 수 있습니다.</div>
					</a>
				</li> -->
				<li>
					<a href="javascript:void(0);" onClick="main.MainGyeol_View();">
						<img src="air-lms/_images/direct05.png" />
						<p><%=StringUtil.getLocaleWord("L.결재문서함", siteLocale) %></p>
						<div><%=StringUtil.getLocaleWord("M.바로가기_결재문서함", siteLocale) %></div>
					</a>
				</li>
			</ul>
			
			<div class="down">
				<a href="javascript:void(0);" onClick="airLms.popupUserManualDownload('<%=loginUser.gethoesaCod()%>');"><img src="air-lms/_images/down01.png" alt="사용자매뉴얼 다운로드"></a>
				<br>
				<a href="javascript:void(0);" onClick="main.goDetail('STD_GY','');"><img src="air-lms/_images/down02.png" alt="표준계약서"></a>
			</div>
		</div>
		
		<div class="board_cover">
			<div class="f_left">
				<input type="hidden" id="list_type" value="GY" />
				<p class="list_title">
					<a onClick="getToDoJSON(1);clickNm(this);" class="list_title_b" data-type='list_title' data-id="to_do"><%=StringUtil.getLocaleWord("L.TO_DO", siteLocale) %></a>
					<span style="font-weight:100; font-size:20px; color:#AAAAAA;">&nbsp;|&nbsp;</span>
					<a onClick="getAprvLJSON(1); clickNm(this);" class="list_title_a" data-type="list_title" data-id="apr"><%=StringUtil.getLocaleWord("L.결재진행", siteLocale) %></a>
				</p>

				<table class="list" id="LmsUsrToDoTable">
					<thead>
					<tr data-opt='{"onClick":"main.goPopupIndex(\"@{STU_GBN}\",\"@{SOL_MAS_UID}\",\"@{GB_DOC_MAS_UID}\",\"@{APR_NO}\")"}'>
						<th style="width:50px" data-opt='{"align":"center","col":"GBN_NAM"}'><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
						<th style="width:100px" data-opt='{"align":"center","col":"GWANRI_NO"}'><%=StringUtil.getLocaleWord("L.관리번호", siteLocale) %></th>
						<th style="width:auto" data-opt='{"align":"center","col":"TITLE"}'><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
						<th style="width:120px" data-opt='{"align":"center","col":"DAMDANG_NAM"}'><%=StringUtil.getLocaleWord("L.담당자", siteLocale) %></th>
						<th style="width:180px" data-opt='{"align":"center","col":"STU_NAM"}'><%=StringUtil.getLocaleWord("L.진행상태", siteLocale) %></th>
						<th style="width:85px" data-opt='{"align":"center","col":"SUJEONG_DTE"}'><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
					</tr>
					</thead>
					<tbody id="LmsUsrToDoTableBody"></tbody>
				</table>
				<%-- 페이지 목록 --%>
				<div class="pagelist" id="LmsUsrToDoTablePage"></div> 
				
				<script>
				var clickNm = function(obj){
					$("a[data-type='list_title']").attr('class','list_title_a');
					$(obj).attr('class','list_title_b');
				}
				//-- 
				var getToDoJSON = function(pageNo){
					if(pageNo == undefined) pageNo =1;
					var data = {};
					data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
					data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
					
					airCommon.callAjax("LMS_MAIN", "USR_TO_DO_JSON",data, function(json){
						airCommon.createTableRow("LmsUsrToDoTable", json, pageNo, 10, "getToDoJSON");
					});
				};
				//-- 결재목록
				var getAprvLJSON = function(pageNo){
					if(pageNo == undefined) pageNo =1;
					var data = {};
					data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
					data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
					
					airCommon.callAjax("LMS_MAIN", "APRV_JSON",data, function(json){
						
						airCommon.createTableRow("LmsUsrToDoTable", json, pageNo, 10, "getAprvLJSON");
					});
				};
				</script>
			</div>
		</div>
	</div>