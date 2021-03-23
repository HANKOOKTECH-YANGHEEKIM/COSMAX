<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	response.setContentType("text/html; charset=UTF-8");
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 요청값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap responseMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	SQLResults FORM_MAS 	= responseMap.getResult("FORM_MAS");
	SQLResults DATA_LIST 	= responseMap.getResult("DATA_LIST");
	SQLResults PATI_LIST 	= responseMap.getResult("PATI_LIST");
	SQLResults APR_LINE 	= responseMap.getResult("APR_LINE");
	SQLResults LMS_MAS		= responseMap.getResult("LMS_MAS");
	
	//-- 파라메터 셋팅
	String actionCode		= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode			= responseMap.getString(CommonConstants.MODE_CODE);
	
	BeanResultMap dataMas = new BeanResultMap();
	if(DATA_LIST != null && DATA_LIST.getRowCount()> 0){
		dataMas.putAll(DATA_LIST.getRowResult(0));
	}
	
	BeanResultMap formMas = new BeanResultMap();
	if(FORM_MAS != null && FORM_MAS.getRowCount()> 0){
		formMas.putAll(FORM_MAS.getRowResult(0));
	}
	
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0){
		lmsMap.putAll(LMS_MAS.getRowResult(0));
	}
	
	String munseo_seosig_no 		= requestMap.getString("MUNSEO_SEOSIG_NO");
	String doc_mas_uid 				= requestMap.getString("DOC_MAS_UID");
	String sol_mas_uid 				= requestMap.getString("SOL_MAS_UID");
	String group_uid 				= requestMap.getString("GROUP_UID");
	
	int his_cnt						= responseMap.getInt("HIS_CNT");
	
	String  isViewMode				= "";		
	boolean isView					= true;		
	boolean isViewHis				= false;		//-- 이력보기 여부		
	boolean isAprS 					= false;		//-- 상취소 가능 여부
	
	//-- 임시저장 문서 체크
	if("TEMP".equals(lmsMap.getString("PROC_GBN")) 
			&& dataMas.getString("LAST_DOC_UID").equals(doc_mas_uid)
			&& !dataMas.getString("WRT_ID").equals(loginUser.getLoginId())){
		isView = false; //-- 임시저장 상태일 경우는  문서는 작성자에게 만 보여지도록 설정
		isViewMode = "TEMP";
	}
	
	if("T".equals(dataMas.getString("DOC_STU"))){
		isView = false; //-- 임시저장 상태일 경우는  문서는 작성자에게 만 보여지도록 설정
		isViewMode = "TEMP";		
	}
	
	//-- 결재중 문서 체크
	if(isView && APR_LINE != null && !APR_LINE.isEmptyRow()){
		if("E".equals(APR_LINE.getString(0, "MAS_APR_STU"))||"R".equals(APR_LINE.getString(0, "MAS_APR_STU"))){
			for(int i=0; i<APR_LINE.getRowCount(); i++){
				if(loginUser.getLoginId().equals(APR_LINE.getString(i, "APR_ID"))){
					isViewHis = true;	//-- 완료문서일경우 히스토리는 결재선내에 사람에게만 버튼이 보인다.
					break;
				}
			}
		}else{
			isView = false;			//-- 결재 진행중일 경우 보기 여부
			isViewMode = "APR";
			for(int i=0; i<APR_LINE.getRowCount(); i++){
				if(loginUser.getLoginId().equals(APR_LINE.getString(i, "APR_ID"))){
					isView = true;	//-- 결재 진행중일 경우 보기 여부
					isViewMode = "";
					break;
				}
			}
		}
		
		isAprS = (true && "S".equals(APR_LINE.getString(0, "MAS_APR_STU")) && APR_LINE.getString(0, "MAS_REG_ID").equals(loginUser.getLoginId()) && !"J".equals(APR_LINE.getString(0, "APR_STU")));
	}
	
	/* 20190621 법무팀 부서일 경우 결재 진행중인 문서 볼 수 있음 */
	if(LmsUtil.isBeobmuTeamUser(loginUser)){
		isView = true;
	}
	
%>

<% if(isView){	//-- 문서 내용 보기 여부%>
	<% if("DEV".equals(CommonProperties.getSystemMode())){%>
	<font color="#DDDDDD">
	MUNSEO_SEOSIG_NO: <%= munseo_seosig_no %><br/>
	GROUP_UID		: <%= group_uid %>&nbsp;&nbsp;&nbsp;&nbsp;FORM_NO		: <%= munseo_seosig_no %>&nbsp;&nbsp;&nbsp;&nbsp;SOL_MAS_UID		: <%= sol_mas_uid %>&nbsp;&nbsp;&nbsp;&nbsp;DOC_MAS_UID 	: <%= doc_mas_uid %>&nbsp;&nbsp;&nbsp;&nbsp;NEXT_FORM_NO 	: <%= dataMas.getString("NEXT_FORM_NO") %><br>
	HIS_CNT 		: <%= responseMap.getInt("HIS_CNT") %><br>
	<!-- </font> -->
	</font>
	<% }%>
	<div class="buttonlist" style="margin:5px 0px 5px 0px;">
	    <div class="right">
	<%if(LmsUtil.isSysAdminUser(loginUser)||LmsUtil.isBeobmuTeamUser(loginUser)){ %>
	    	<span class="ui_btn small icon"><span class="modify"></span><a href="javascript:void(0)" onclick="airCommon.openDocUpdate('<%=doc_mas_uid%>','<%=sol_mas_uid%>');"><%=StringUtil.getLocaleWord("B.EDIT",siteLocale)%></a></span>
	<%} %>
	<%if(isViewHis && his_cnt > 1){ %>
	    	<span class="ui_btn small icon"><span class="list"></span><a href="javascript:void(0)" onclick="airCommon.doOpenHistory('<%=group_uid%>');">이력<%-- <%=StringUtil.getLocaleWord("B.개정이력",siteLocale)%> --%></a></span>
	<%} %>
	<%
	if(!"VIEW_PRINT".equals(modeCode)){
	%>	
		<span class="ui_btn small icon"><span class="print"></span><a href="javascript:void(0)" onclick="airCommon.doPopupPrintOpen('<%=munseo_seosig_no%>','<%=doc_mas_uid%>')"><%=StringUtil.getLocaleWord("B.PRINT",siteLocale)%></a></span>
	<%}%>
	    </div>
	</div>
	<% if(!PATI_LIST.isEmptyRow()){%>
		<%for(int i=0; i<PATI_LIST.getRowCount(); i++){%>
			<%String mng_pati_uid = PATI_LIST.getString(i,"mng_pati_uid");%>
			<%String pati_johoe_auth_codes = PATI_LIST.getString(i,"pati_johoe_auth_codes");%>
			<%if(loginUser.isUserAuth(pati_johoe_auth_codes)){%>	
				<%if("DEV".equals(CommonProperties.getSystemMode())){%>	
			<font color="#DDDDDD">++시작 : <%= PATI_LIST.getString(i, "PATI_GWANRI_NO") %>++</font><br>
				<%}%>
			<input type="hidden" name="mng_pati_uid" value="<%=mng_pati_uid%>">
			<jsp:include page="/ServletController" flush="false">
				<jsp:param value="<%=mng_pati_uid%>" 	    name="AIR_PARTICLE"/>
				<jsp:param value="<%=sol_mas_uid%>" 	    name="sol_mas_uid"/>
				<jsp:param value="<%=doc_mas_uid%>" 	    name="doc_mas_uid"/>
				<jsp:param value="<%=modeCode%>"		   name="doc_mas_mode_code"/>
				<jsp:param value="<%=munseo_seosig_no%>" 	name="munseo_seosig_no"/>
				<jsp:param value="VIEW" name="AIR_MODE"/>
			</jsp:include>
			<%}else{%>
				<%if("DEV".equals(CommonProperties.getSystemMode())){%>
				<div style="line-height:80px;background-color:#f7f7f7;border: 1px solid #999;text-align:center; ">
					<span>
					   열람권한이 없습니다.
					</span>
				</div>
				<%}%>
			<%}%>
		<%}%>
	<%}%>
	<% if("Y".equals(formMas.getString("GIBON_MEMO_DSP_YN"))){%>
		<table class="basic">
			<%if(StringUtil.isNotBlank(jsonMap.getString("LMS_PATI_BASE_CAPTION"))){ %>
			<caption><%=jsonMap.getStringView("LMS_PATI_BASE_CAPTION") %></caption>
			<%} %>
			<tr>
				<th class="th4"><%=StringUtil.getLocaleWord("L.작성자", siteLocale) %></th>
				<td class="td4">
					<%=dataMas.getStringView("WRT_NM") %>
				</td>
				<th class="th4"><%=StringUtil.getLocaleWord("L.작성일", siteLocale) %></th>
				<td class="td4">
					<%=dataMas.getStringView("WRT_DTE") %>
				</td>
			</tr>
			<tr>
				<th class="th2"><%=jsonMap.getDefStr("LMS_PATI_BASE_LABEL", StringUtil.getLocaleWord("L.메모", siteLocale)) %></th>
				<td class="td2" colspan="3">
					<%=jsonMap.getStringView("LMS_PATI_BASE_MEMO") %>
				</td>
			</tr>
		</table>
	<%}%>
	
	<% if(APR_LINE != null && !APR_LINE.isEmptyRow()){%>
	<br />
	<%if("DEV".equals(CommonProperties.getSystemMode())){%>	
		<font color="#DDDDDD">APR_NO : <%= APR_LINE.getString(0, "APR_NO") %>++</font><br>
	<%}%>
	<%if(isAprS){ %>
	<script>
		var doAprCancel<%=sol_mas_uid%> = function(){
			
			if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "L.결재요청_취소")%>")){
				var data = {};
				data["sol_mas_uid"] = "<%=sol_mas_uid%>";
				data["doc_mas_uid"] = "<%=doc_mas_uid%>";
				data["apr_no"] = "<%=APR_LINE.getString(0, "APR_NO")%>";
				airCommon.callAjax("SYS_APR", "APR_CANCEL",data, function(json){
					
					alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>");
					try{
						//--그리드 리스트 refresh
						opener.doSearch(opener.document.form1);
					}catch(e){
						try{
							//-- 메인 화면 refresh
							opener.initMain();
						}catch(e){
							
						}
					}
					
					location.href = location.href;
				});
			}
		}
	</script>
	<%}%>
	<table class="basic">
	<caption>
		<span class="left"><%=StringUtil.getLocaleWord("L.결재정보", siteLocale) %></span>
		<span class="right">
			<%if(isAprS){ %>
				<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doAprCancel<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("L.결재요청_취소",siteLocale)%></a></span>
			<%} %>
		</span>
	</caption>
	<thead>
	<tr>
		<th style="width:10%;text-align:center;"><%=StringUtil.getLocaleWord("L.진행상태", siteLocale) %></th>
		<th style="width:8%;text-align:center;"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
		<th style="width:10%;text-align:center;"><%=StringUtil.getLocaleWord("L.처리일자", siteLocale) %></th>
		<th style="width:25%;text-align:center;"><%=StringUtil.getLocaleWord("L.결재자정보", siteLocale) %></th>
		<th style="width:*;text-align:center;"><%=StringUtil.getLocaleWord("L.메모", siteLocale) %></th>
	</tr>
	</thead>
	<tbody>
	<%
		for(int i=0; i<APR_LINE.getRowCount(); i++){
			BeanResultMap rowMap = APR_LINE.getRowResult(i) ;
			
			String highlignt="";
			String rhighlignt="";
			if("W".equals(rowMap.getString("APR_STU")))
				highlignt = "background: #FFDFDF;";
			if("R".equals(rowMap.getString("APR_STU")))
				rhighlignt = "background: #FFDFDF;";
	%>
		<tr>
			<td style="text-align:center;<%=highlignt%> "><%=rowMap.getString("APR_STU_NM") %></td>
			<td style="text-align:center;<%=highlignt%>"><%=rowMap.getString("APR_TYPE_NM") %></td>
			<td style="text-align:center;<%=highlignt%>"><%=rowMap.getString("APR_DTE") %></td>
			<td style="text-align:left;<%=highlignt%>">
				<%--=rowMap.getString("GROUP_NAME_KO") --%> <%=rowMap.getString("APR_NM") %> <%--=rowMap.getString("POSITION_NAME_KO") --%>
			</td>
			<td style="<%=highlignt%>"><%=rowMap.getStringView("APR_MEMO") %></td>
		</tr>
			<%-- 
			<%if(loginUser.isUserAuth(pati_johoe_auth_codes)){%>	
			
			<%}else{%>
				<%if("DEV".equals(CommonProperties.getSystemMode())){%>
				<div style="line-height:80px;background-color:#f7f7f7;border: 1px solid #999;text-align:center; ">
					<span>
					   결재 정보 열람 권한 없음
					</span>
				</div>
				<%}%>
			<%}%>
			 --%>
		<%}%>
	</tbody>
	</table>
	<%}%>
<%}else{%>
	<%if("APR".equals(isViewMode)){%>
	<div class="wrap-indent">
		<div style="line-height:80px;background-color:#f7f7f7;border: 1px solid #999;text-align:center; ">
			<span>
			   <%=StringUtil.getLocaleWord("M.결재진행중문서", siteLocale) %>
			</span>
		</div>
	</div>
	<%}else{%>
	<div class="wrap-indent">
		<div style="line-height:80px;background-color:#f7f7f7;border: 1px solid #999;text-align:center; ">
			<span>
			   <%=StringUtil.getLocaleWord("M.임시저장중문서", siteLocale) %>
			</span>
		</div>
	</div>
	<%}%>
<%}//--결재중일경우 보기 권한%>
<%if("VIEW_PRINT".equals(modeCode)){%>	
<script>
setTimeout(function() { window.print(); }, 3000);
</script>
<br/>
<br/>
<br/>
<%}%>