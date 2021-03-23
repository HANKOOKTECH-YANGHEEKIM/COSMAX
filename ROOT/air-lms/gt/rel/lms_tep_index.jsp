<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
SQLResults rsRelList	= resultMap.getResult("REL_LIST");
String sol_mas_uid 		= resultMap.getString("SOL_MAS_UID");
String gwanri_mas_uid 	= resultMap.getString("GWANRI_MAS_UID");
String org_action		= resultMap.getString("ORG_ACTION");
String org_mode			= resultMap.getString("ORG_MODE");
String titleNo			= resultMap.getString("TITLE_NO");
String uuid				= resultMap.getString("UUID");
String board_cd			= resultMap.getString("BOARD_CD");
String guBun			= org_action.replace("LMS_", "").replace("_TEP", "");

String locateUrl		= "/ServletController?AIR_ACTION="+org_action+"&AIR_MODE="+org_mode+"&sol_mas_uid="+ sol_mas_uid +"&gwanri_mas_uid="+ gwanri_mas_uid +"&title_no="+ titleNo;
locateUrl +=	"&UUID="+uuid; 
locateUrl +=	"&BOARD_CD="+board_cd;

boolean isBoebmuTeam = LmsUtil.isBeobmuTeamUser(loginUser);
boolean isBbTeam = LmsUtil.isBeobmuOfiUser(loginUser);
%>
<script>
<% if(rsRelList.isEmptyRow()|| StringUtils.isBlank(sol_mas_uid)){%>
	location.href  = "<%=locateUrl%>";
<%-- 
var tab = $('#listTabsLayer').tabs('getSelected');  // get selected panel
$('#listTabsLayer').tabs('update', {
	tab: tab,
	options: {
		title: '<%=titleNo%>',
		href: '<%=locateUrl%>'  // the new content URL
	}
});
 --%>

<% }%>

var m_resizingTepFrameCodes = new Object(); //리사이징 작업중인 TEP 프레임 코드's
var m_isTepParentFrameResizing = false;	//부모 프레임 리사이징 작업중 여부

/**
 * TEP 프레임 리사이즈
 */
function tep_frameResize(code) {
	//console.log("m_resizingTepFrameCodes[code] is "+ m_resizingTepFrameCodes[code]);
	if (code != "" && code != m_resizingTepFrameCodes[code]) {		
		m_resizingTepFrameCodes[code] = code;
		
		setTimeout(
				function() {
					try {
						airCommon.resizeIFrame("tepIndexFrame-"+ code, "100%", "auto");
					} catch (e) {
						alert('Error');		
					}
					
					m_resizingTepFrameCodes[code] = null;	
					
					tep_parentFrameResize();
				},
				800
		);								
	}
}
function initList(){
	self.close();
	opener.location.reload();
}
/**
 * 부모 프레임 리사이즈
 */
function tep_parentFrameResize() {		
	var code = "<%=titleNo%>";
			
	//console.log("[tep_parentFrameResize()] code : " + code);
	
	if (!m_isTepParentFrameResizing && code != "") {
		m_isTepParentFrameResizing = true;
		
		setTimeout(
				function() {
					try {
						var scroll_top = $(parent.document).scrollTop();
						parent.airCommon.resizeIFrame("listTabsFrame-"+ code, "100%", "auto");
						$(parent.document).scrollTop(scroll_top);
						
						//console.log("parent document scrollTop is "+ $(parent.document).scrollTop());
						//console.log("parent document height is "+ $(parent.document).height());
					} catch (e) {
						console.log("[tep_parentFrameResize()] 에러가 발생했습니다.\nError Message : " + e.message);			
					}
					
					m_isTepParentFrameResizing = false;														
					
				},
				0
		);
	}		
}

/**
 * TEP 탭 프레임 초기화
 */
function tep_frameInit(tabCode) {	
	var ifrm = $("#tepIndexFrame-"+ tabCode);
	var defaultSrc = ifrm.attr("data-defaultSrc");		
	if (!ifrm.attr("src") && defaultSrc) {	
		// IFrame의 경로가 초기화되지 않은 경우에만 디폴트 값으로 초기화 수행
		ifrm.attr("src", defaultSrc);
		
		// IFrame 로드 이벤트 처리
		ifrm.load(function() {
			// TEP 탭 프레임 리사이즈
			tep_frameResize(tabCode);
		});					
	} else {
		
		// TEP 탭 프레임 리사이즈
		tep_frameResize(tabCode);
		// 부모 프레임 리사이즈
		tep_parentFrameResize();
	}
}
var resizeFrame = function(id){
	setTimeout(
			function() {
				try {
					var scroll_top = $(parent.document).scrollTop();
					parent.airCommon.resizeIFrame("tepIndexFrame-"+ code, "100%", "auto");
					$(parent.document).scrollTop(scroll_top);
					
					//console.log("parent document scrollTop is "+ $(parent.document).scrollTop());
					//console.log("parent document height is "+ $(parent.document).height());
				} catch (e) {
					//console.log("[tep_parentFrameResize()] 에러가 발생했습니다.\nError Message : " + e.message);			
				}
				
				m_isTepParentFrameResizing = false;														
				
			},
			800
	);
}
var loadRel = function(id){
	//var rel_sol_mas_uid 	= $("#"+id).find("input:hidden[name='rel_sol_mas_uid']").val();
	//var rel_gwanri_mas_uid 	= $("#"+id).find("input:hidden[name='rel_gwanri_mas_uid']").val();
	//var rel_title_no 	= $("#"+id).find("input:hidden[name='rel_title_no']").val();
	//var gubun		 	= $("#"+id).find("input:hidden[name='rel_gubun']").val();
	//var old_yn		 	= $("#"+id).find("input:hidden[name='old_yn']").val();
	var gubun		 	= "<%=guBun%>";
	var rel_title_no 	= "<%=titleNo%>";
	var rel_gwanri_mas_uid 	= "<%=gwanri_mas_uid%>";
	var rel_sol_mas_uid 	= "<%=sol_mas_uid%>"
	var old_yn		 	= 	"";
	if ($("#tepIndexLayer").tabs("exists", rel_title_no)) {
		$("#tepIndexLayer").tabs("close", rel_title_no);
	}
	var url = "";

	if("SS" == gubun || "BJ" == gubun){
		if("Y" == old_yn){
			url ="\"AIR_ACTION=LMS_SS_MAS&AIR_MODE=OLD_POPUP_VIEW&sol_mas_uid="+ rel_sol_mas_uid +"&gwanri_mas_uid="+ rel_gwanri_mas_uid +"&title_no="+ rel_title_no +"\""
		}else{
			url = "\"/ServletController?AIR_ACTION=LMS_SS_TEP&AIR_MODE=INDEX&sol_mas_uid="+ rel_sol_mas_uid +"&gwanri_mas_uid="+ rel_gwanri_mas_uid +"&title_no="+ rel_title_no +"\"";
		}
	}else if("GY" == gubun){
		url = "\"/ServletController?AIR_ACTION=LMS_GY_TEP&AIR_MODE=INDEX&sol_mas_uid="+ rel_sol_mas_uid +"&gwanri_mas_uid="+ rel_gwanri_mas_uid +"&title_no="+ rel_title_no +"\"";
	}else if("JM" == gubun){
		if("Y" == old_yn){
			url	= "\"/ServletController?AIR_ACTION=LMS_JM_OLD_LIST&AIR_MODE=VIEW&sol_mas_uid="+ rel_sol_mas_uid +"&gwanri_mas_uid="+ rel_gwanri_mas_uid +"\"";		
		}else{
			url = "\"/ServletController?AIR_ACTION=LMS_JM_TEP&AIR_MODE=INDEX&sol_mas_uid="+ rel_sol_mas_uid +"&gwanri_mas_uid="+ rel_gwanri_mas_uid +"&title_no="+ rel_title_no +"\"";
		}
	}else if("IJ" == gubun){
		url = "<%=locateUrl%>";
	}

	var content = "<iframe name=\"listTabsFrame2-"+ rel_title_no +"\" id=\"listTabsFrame2-"+ rel_title_no +"\""
	+ " scrolling=\"no\" frameborder=\"0\" "			
	+ " style=\"border:0;width:100%;height:1500px\""
	+ " src="	+url
	+ "></iframe>"; 

	$("#tepIndexLayer").tabs("add", {	
		id:'listTabs-'+rel_title_no,
		title:rel_title_no,
		content:content,
		closable:true,
		iconCls:'icon-document',
		style:{paddingTop:'5px'}
	});
}

var deleteRel = function(gubun,rel_sol_mas_uid, sol_mas_uid){
	var message = "<%=StringUtil.getLocaleWord("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.삭제", siteLocale))%>";
	if(confirm(message)){
		$.ajax({
	    	url: "/ServletController"
	    	, type: "POST"
			, dataType: "json"
			, data: {
					"AIR_ACTION":"LMS_REL_MAS",
					"AIR_MODE":"DELETE_PROC",
					"gubun":gubun,
					"sol_mas_uid":sol_mas_uid,
					"rel_sol_mas_uid":rel_sol_mas_uid
				}
		})
		.done(function() {
			self.location.reload();
	    })
	    .fail(function() {
	        alert("삭제중 문제가 발생하였습니다.\n관리자에게 문의해 주세요.");
	    });
	}else{
		return false;
	}
}
</script>

<table id="relTable" class="basic">
	<caption><%=StringUtil.getLocaleWord("L.관련_계약_자문_소송",siteLocale)%></caption>	
		<colgroup>			
			<col width="10%" />
			<col width="12%" />
			<col width="*" />
			<col width="10%" />
			<col width="8%" />
			<col width="10%" />
			<%if(isBoebmuTeam){ %>
			<col width="4%" />
			<%}%>
		</colgroup>
		<thead>
		<tr>			
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.사건명",siteLocale)%></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.의뢰일_작성일",siteLocale)%></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
			<th style="text-align:center"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale)%></th>
			<%if(isBoebmuTeam){ %>
				<th></th>
			<%}%>
		</tr>
		</thead>
		<tbody>
<%
	StringBuffer simViewTabsHtml = new StringBuffer();
if(!rsRelList.isEmptyRow()){
	String isNone = "none;";
	for (int i=0; i<rsRelList.getRowCount(); i++) {
		String rel_sol_mas_uid = rsRelList.getString(i, "SOL_MAS_UID");
		String rel_gwanri_mas_uid = rsRelList.getString(i, "GWANRI_MAS_UID");
		String reg_dte = rsRelList.getString(i, "REG_DTE");
		String gubun = rsRelList.getString(i, "GUBUN");
		String gubun_name = rsRelList.getString(i, "GUBUN_NAME");
		String title_no = rsRelList.getString(i, "TITLE_NO");
		String title    = rsRelList.getString(i, "TITLE");
		String damdang_nam	= rsRelList.getString(i, "DAMDANG_NAM");
		String sangtae_nam  = rsRelList.getString(i, "SANGTAE_NAM");
		String old_yn    = rsRelList.getString(i, "OLD_YN");
		String disp = "";

		if(sol_mas_uid.equals(rel_sol_mas_uid)){
			disp = isNone;
		}
%>
		<tr id="<%=rel_sol_mas_uid%>" style="display:<%=disp%>">
			<td align="center" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;"><%=StringUtil.convertForView(gubun_name)%></td>
			<td align="center" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;">
				<%=StringUtil.convertForView(title_no)%>
				<input type="hidden" name="rel_sol_mas_uid" id="rel_sol_mas_uid" value="<%=rel_sol_mas_uid%>"/>
				<input type="hidden" name="rel_gwanri_mas_uid" id="rel_gwanri_mas_uid" value="<%=rel_gwanri_mas_uid%>"/>
				<input type="hidden" name="rel_title_no" id="rel_title_no" value="<%=title_no%>"/>
				<input type="hidden" name="rel_gubun" id="rel_gubun" value="<%=gubun%>"/>
				<input type="hidden" name="old_yn" id="old_yn" value="<%=old_yn%>"/>
			</td>
			<td align="left" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;"><%=StringUtil.convertForView(title)%></td>
			<td align="center" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;"><%=StringUtil.convertForView(reg_dte)%></td>
			<td align="center" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;"><%=StringUtil.convertForView(damdang_nam)%></td>
			<td align="center" onclick="loadRel('<%=rel_sol_mas_uid%>');" style="cursor: pointer;"><%=StringUtil.convertForView(sangtae_nam)%></td>
			<%if(isBoebmuTeam){ %>
			<td align="center">
				<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onClick="deleteRel('<%=guBun %>','<%=rel_sol_mas_uid%>','<%=sol_mas_uid%>')"></a></span>
			</td>
			<%}%>
		</tr>
<%		
		if(sol_mas_uid.equals(rel_sol_mas_uid) && "".equals(isNone)){
			isNone = "none";
		}
	}
}
%>		
	</tbody>			
</table>
<br />
<div id="tepIndexLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
</div>	
<script>
$(function(){
	$("#tepIndexLayer").tabs({
		onSelect:function(title,index){
			if (0 == index) {						
				/* 상세조회 후 목록 새로고침 기능 비활성화
				doSearch(document.form1);
				*/
			}
		},
		onClose:function(title,index){			
			/* 상세조회 후 목록 새로고침 기능 비활성화
			doSearch(document.form1);	
			*/
		}
	});
 	tep_parentFrameResize();
 	
	loadRel("<%=sol_mas_uid%>");
	
	
	// 리사이징 처리
	$(window).resize(function(){
	 	
		//tep_parentFrameResize();
	});
	
});
</script>	
