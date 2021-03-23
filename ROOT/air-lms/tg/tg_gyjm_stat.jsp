<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.05
  - 
  - @(#)
  - Description : 통계 - 계약/자문 의뢰현황
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo              	 = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String menuNm					= requestMap.getString(siteLocale);
 
	String schDateFrom = requestMap.getString("SCHDATEFROM");
	String schDateTo = requestMap.getString("SCHDATETO");
	String schDeptNm			= requestMap.getString("SCHDEPTNM");
	String schHoesaCd			= requestMap.getString("SCHHOESACD");
	String schHoesaNm			= requestMap.getString("SCHHOESANM");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
		
	SQLResults rsTgData = resultMap.getResult("GYJM_STAT");
	
	//-- 코드정보 문자열 셋팅
	String 부서_팀 		= StringUtil.getLocaleWord("L.부서_팀",siteLocale);
	String 기간 			= StringUtil.getLocaleWord("L.기간",siteLocale);
	String 진행 			= StringUtil.getLocaleWord("L.요청",siteLocale);
	String 완료 			= StringUtil.getLocaleWord("L.완료",siteLocale);
	String No 			= StringUtil.getLocaleWord("L.Num",siteLocale);
	String 합계 			= StringUtil.getLocaleWord("L.합계",siteLocale);
	String 회사		    = StringUtil.getLocaleWord("L.회사",siteLocale);
	String 검색결과가없습니다 		= StringUtil.getLocaleWord("M.검색결과가없습니다",siteLocale);
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
%> 
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form name="form1" method="post">	
<input type="hidden" name="<%=siteLocale %>" value="<%=requestMap.getString("MENU_NAME_KO")%>" />
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<table class="box">
	<tr>
		<td class="corner_lt"></td>
		<td class="border_mt"></td>
		<td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:8%;" />
					<col style="width:23%;" />
					<col style="width:8%;" />
					<col style="width:23%;" />
					<col style="width:8%;" />
					<col style="width:auto;" />
					<col style="width:130px;" />
				</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.기간",siteLocale) %></th>
					<td>
						<select name="schYear" data-type="search" style="width:70px;">
							<%=HtmlUtil.getSelectboxCalendar("YEAR", 2018, -1, requestMap.getString("SCHYEAR")) %>
						</select>
					</td>
					<th><%=StringUtil.getLocaleWord("L.회사",siteLocale) %></th>  
					<td>
						<% if(loginUser.getAuthCodes().contains("CMM_SYS")){ %>
							<%=HtmlUtil.getSelect(request, true, "schHoesaCd", "schHoesaCd", HOESA_CODESTR, loginUser.gethoesaCod(), "style=\"width:100%;\" class=\"select\"")%>
						<%}else{ %>
							<%=HtmlUtil.getSelect(request, false, "schHoesaCd", "schHoesaCd", HOESA_CODESTR, loginUser.gethoesaCod() , "style=\"width:100%;\" class=\"select\"").replace("C.", "")%>
						<%} %>
					</td> 
					<th></th>
					<td></td>
					<td style="text-align:center;">
					    <span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>						
					</td>
				</tr>
			</table>	
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td>
		<td class="border_mb"></td>
		<td class="corner_rb"></td>
	</tr>							
	</table>
	<div class="buttonlist">
		<div class="left">
			<span style="color:red"><%=StringUtil.getLocaleWord("M.법무팀업무현황계약기준",siteLocale)%></span>
		</div>
		<div class="right">
	    	<script>
			/*
			 * 엑셀다운로드
			 */
			function doExcelDown(frm){
				frm.action = "/ServletController";
				frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
				frm.<%=CommonConstants.MODE_CODE%>.value = "GYJM_STAT_EXCEL";
				frm.target = "airBackgroundProcessFrame";
				frm.submit();
			}
			</script>
			<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>		
		</div>
		<div class="right">
		</div>								
	</div>
	<table id="hoesa_select"   class="basic">
		<colgroup>
			<col style="width:5%">
			<col style="width:auto">			
			<col style="width:auto">
			<col style="width:8%">
			<col style="width:8%">
			<col style="width:8%">
			<col style="width:8%">
			<col style="width:8%">
			<col style="width:8%">
<!-- 			<col style="width:8%"> -->
<!-- 			<col style="width:8%">  -->
			<col style="width:8%">
			<col style="width:8%"> 
		</colgroup>
		<tr>
			<th rowspan="2"  style="text-align:center">No.</th>
			<th rowspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
			<th rowspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.팀",siteLocale)%></th>
			<th colspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.계약",siteLocale) %></th>
			<th colspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.자문",siteLocale)%></th>
<%-- 			<th colspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.소송",siteLocale)%></th> --%>
			<th colspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.합계",siteLocale)%></th>
		</tr>
		<tr>
			<th style="text-align:center"><%=진행 %></th>
			<th style="text-align:center"><%=완료%></th>
			<th style="text-align:center"><%=진행 %></th>
			<th style="text-align:center"><%=완료%></th>
<%-- 			<th style="text-align:center"><%=계류 %></th> --%>
<%-- 			<th style="text-align:center"><%=종결%></th>  --%>
			<th style="text-align:center"><%=진행 %></th>
			<th style="text-align:center"><%=완료%></th>
		</tr>
		<tbody id="damdangBody">
<%
	//차트 데이터 생성
	String chartData = "";
	int iLimitRow = 0;
	
	if(rsTgData != null && rsTgData.getRowCount() > 0){
		int sg_gy_jh = 0, sg_gy_wr=0, sg_jm_jh=0, sg_jm_wr=0, sg_ss_jh=0, sg_ss_wr=0, sg_tot_jh=0, sg_tot_wr=0; //소계
		int sum_gy_jh = 0, sum_gy_wr=0, sum_jm_jh=0, sum_jm_wr=0, sum_ss_jh=0, sum_ss_wr=0, sum_tot_jh=0, sum_tot_wr=0; //합계
		int iSg = 0;
		
		for(int i=0; i< rsTgData.getRowCount(); i++){
			iSg ++;
			int sumJh = 0;
			int sumWr = 0;
			String HOESA_NAM = rsTgData.getString(i, "COMPANY_NAME");
			int iGROUP_COUNT = Integer.parseInt(rsTgData.getString(i, "GROUP_COUNT"));
			String GROUP_NAME = rsTgData.getString(i, "NAME_"+siteLocale);
			String LOGIN_ID = rsTgData.getString(i, "LOGIN_ID");
			//String TYPE_NAM = rsTgData.getString(i, "TYPE_"+siteLocale);
			String GY_JH_CNT = rsTgData.getString(i, "GY_JH_CNT");
			String GY_WR_CNT = rsTgData.getString(i, "GY_WR_CNT");
			String JM_JH_CNT = rsTgData.getString(i, "JM_JH_CNT");
			String JM_WR_CNT = rsTgData.getString(i, "JM_WR_CNT");
// 			String SS_JH_CNT = rsTgData.getString(i, "SS_JH_CNT");
// 			String SS_WR_CNT = rsTgData.getString(i, "SS_WR_CNT");
			String SUM_JH_CNT = rsTgData.getString(i, "SUM_JH_CNT");
			String SUM_WR_CNT = rsTgData.getString(i, "SUM_WR_CNT"); 
			sumJh = Integer.parseInt(GY_JH_CNT)+Integer.parseInt(JM_JH_CNT);
			sumWr = Integer.parseInt(GY_WR_CNT)+Integer.parseInt(JM_WR_CNT);

			//소계 계산
			sg_gy_jh += Integer.parseInt(GY_JH_CNT);
			sg_gy_wr += Integer.parseInt(GY_WR_CNT);
			sg_jm_jh += Integer.parseInt(JM_JH_CNT);
			sg_jm_wr += Integer.parseInt(JM_WR_CNT);
// 			sg_ss_jh += Integer.parseInt(SS_JH_CNT);
// 			sg_ss_wr += Integer.parseInt(SS_WR_CNT);
			sg_tot_jh += sumJh;
			sg_tot_wr += sumWr;
			
			//합계 계산
			sum_gy_jh += Integer.parseInt(GY_JH_CNT);
			sum_gy_wr += Integer.parseInt(GY_WR_CNT);
			sum_jm_jh += Integer.parseInt(JM_JH_CNT);
			sum_jm_wr += Integer.parseInt(JM_WR_CNT);
// 			sum_ss_jh += Integer.parseInt(SS_JH_CNT);
// 			sum_ss_wr += Integer.parseInt(SS_WR_CNT);
			sum_tot_jh += sumJh;
			sum_tot_wr += sumWr;
			
			//차트 데이터 생성
			if(i>0)chartData+=",";
			chartData+="{ DAMDANG:'"+GROUP_NAME+"',GY_JH_CNT:"+GY_JH_CNT+",JM_JH_CNT:"+JM_JH_CNT+",JM_WR_CNT:"+JM_WR_CNT+"}";
			if(iLimitRow < Integer.parseInt(GY_JH_CNT))iLimitRow = Integer.parseInt(GY_JH_CNT);
			if(iLimitRow < Integer.parseInt(GY_WR_CNT))iLimitRow = Integer.parseInt(GY_WR_CNT);
			if(iLimitRow < Integer.parseInt(JM_JH_CNT))iLimitRow = Integer.parseInt(JM_JH_CNT);
			if(iLimitRow < Integer.parseInt(JM_WR_CNT))iLimitRow = Integer.parseInt(JM_WR_CNT);
// 			if(iLimitRow < Integer.parseInt(SS_JH_CNT))iLimitRow = Integer.parseInt(SS_JH_CNT);
// 			if(iLimitRow < Integer.parseInt(SS_WR_CNT))iLimitRow = Integer.parseInt(SS_WR_CNT);
%>
		<tr id="<%=LOGIN_ID %>" style='text-align:center'>
			<td><%=(i+1) %></td>
			<td><%=HOESA_NAM %></td>
			<td><%=GROUP_NAME %></td>
			<td style="text-align:right;"><%=GY_JH_CNT %></td>
			<td style="text-align:right;"><%=GY_WR_CNT %></td>
			<td style="text-align:right;"><%=JM_JH_CNT %></td>
			<td style="text-align:right;"><%=JM_WR_CNT %></td>
<%-- 			<td style="text-align:right;"><%=SS_JH_CNT %></td> --%>
<%-- 			<td style="text-align:right;"><%=SS_WR_CNT %></td> --%>
			<td style="text-align:right;"><%=SUM_JH_CNT %></td>
			<td style="text-align:right;"><%=SUM_WR_CNT %></td>
		</tr> 
<%
			if (iSg==iGROUP_COUNT) {
%>
				<tr style='text-align:center'>
					<td></td> 
					<td colspan="2"><b><%=StringUtil.getLocaleWord("L.소계",siteLocale)  %></b></td> 
					<td style="text-align:right;"><b><%=sg_gy_jh %></b></td> 
					<td style="text-align:right;"><b><%=sg_gy_wr %></b></td> 
					<td style="text-align:right;"><b><%=sg_jm_jh %></b></td> 
					<td style="text-align:right;"><b><%=sg_jm_wr %></b></td> 
<%-- 					<td style="text-align:right;"><b><%=sg_ss_jh %></b></td>  --%>
<%-- 					<td style="text-align:right;"><b><%=sg_ss_wr %></b></td> --%>
					<td style="text-align:right;"><b><%=sg_tot_jh %></b></td> 
					<td style="text-align:right;"><b><%=sg_tot_wr %></b></td> 
				</tr>
<%
				iSg = 0;
				sg_gy_jh = 0;
				sg_gy_wr = 0;
				sg_jm_jh = 0;
				sg_jm_wr = 0;
				sg_ss_jh = 0;
				sg_ss_wr = 0;
				sg_tot_jh = 0;
				sg_tot_wr = 0;
			}
		}
%>
		<tr style='text-align:center'>
			<td colspan="3"><b><%=StringUtil.getLocaleWord("L.합계",siteLocale)  %></b></td> 
			<td style="text-align:right;"><b><%=sum_gy_jh  %></b></td> 
			<td style="text-align:right;"><b><%=sum_gy_wr  %></b></td> 
			<td style="text-align:right;"><b><%=sum_jm_jh  %></b></td> 
			<td style="text-align:right;"><b><%=sum_jm_wr  %></b></td> 
<%-- 			<td style="text-align:right;"><b><%=sum_ss_jh  %></b></td>  --%>
<%-- 			<td style="text-align:right;"><b><%=sum_ss_wr  %></b></td> --%>
			<td style="text-align:right;"><b><%=sum_tot_jh %></b></td> 
			<td style="text-align:right;"><b><%=sum_tot_wr %></b></td> 
		</tr>
<%
	}
%>
		</tbody> 
	</table>
</form>
</div>
</div>
<script>
function doReset(frm){
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale) %>")) {
		frm.reset();
	    $("#schYear").val("<%=Calendar.getInstance().get(Calendar.YEAR) %>");
	    $("#schHoesaCd").val("");	    
	}
}
 
function doSearch(frm, isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	} 
	
	frm.action = "/ServletController";
	frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
	frm.<%=CommonConstants.MODE_CODE%>.value = "<%=modeCode%>";
	frm.target = "_self";
	frm.submit();
}

/* 
 * 
 * 같은 값이 있는 열을 병합함
 * 
 * 사용법 : $('#테이블 ID').rowspan(0);
 * 
 */    
$.fn.rowspan2 = function(colIdx, isStats) {       
    return this.each(function(){      
        var that;    
        $('tr', this).each(function(row) {      
            $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
                if ($(this).html() == $(that).html()&& ((!isStats || isStats && $(this).prev().html() == $(that).prev().html()) 

                                                                    && $(this).html() !="<%=StringUtil.getLocaleWord("L.합계",siteLocale) %>" )) { // 값이 '소계' 이면 rowspan 안함.   
                    rowspan = $(that).attr("rowspan") || 1;
                    rowspan = Number(rowspan)+1;
                    
                    $(that).attr("rowspan",rowspan);
                    // do your action for the colspan cell here            
                    $(this).hide();
                    
                    //$(this).remove(); 
                    // do your action for the old cell here
                } else {            
                    that = this;         
                }     
                
                $('#hoesa_select').colspan(row); // row 돌때 마다 colspan
                 
                // set the that if not already set
                that = (that == null) ? this : that;
                
            });     
        });    
    });  
}; 

/* 
 * 
 * 같은 값이 있는 행을 병합함
 * 
 * 사용법 : $('#테이블 ID').colspan (0);
 * 
 */  
$.fn.colspan = function(rowIdx) {
 // alert("col  :  "+rowIdx);
    return this.each(function(){
        var that;
        $('tr', this).filter(":eq("+rowIdx+")").each(function(row) {
            $(this).find('td').filter(':visible').each(function(col) {
            	
                if ($(this).html() == $(that).html()) {
                    colspan = $(that).attr("colSpan") || 1;
                    colspan = Number(colspan)+1;
                    if( col <3 ){
                        $(that).attr("colSpan",colspan);
                        $(this).hide(); // .remove();  
                    }
                } else {
                    that = this;
                }
                 
                // set the that if not already set
                that = (that == null) ? this : that;
            });
        });
    });
} 

$(document).ready(function() {	
	if( $('#schHoesaCd option:selected').val() == ''){ 
		    $("[data-col='dept']").hide(); 
	}else{
		$("[data-col='dept']").show(); 
	     	
	}   
}); 
</script>
<%--
<script type="text/javascript">
function goPopUpStat(JinhaengSangTae, hoesaCod, yocheongCod, gubun, gubun_all){
	
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_TG";
	url += "&AIR_MODE=POPUP_GYJM_LIST";
	url += "&schGuBun=ALL";
	url += "&shJinHaengSangTae="+JinhaengSangTae;
	url += "&schHoesaCod="+hoesaCod;
	url += "&shYocheongDptCod="+yocheongCod;
	url += "&schDateFrom="+$("#schDateFrom").val();
	url += "&schDateTo="+$("#schDateTo").val();
	url += "&GUBUN="+gubun; 
	url += "&GUBUN_ALL="+gubun_all;
	
	airCommon.openWindow(url, "1024", "370", "POPUP_VIEW", "yes", "yes", ""); 
}
</script>
<%
//Chart
String sCoreChart1 = "";

if(rsTgData != null && rsTgData.getRowCount() > 0){
	for(int i=0; i< rsTgData.getRowCount()-1; i++){
		String HOESA_NAM = StringUtil.convertNull(rsTgData.getString(i, "HOESA_NAM"));
		String GY_JH_CNT = StringUtil.convertNull(rsTgData.getString(i, "GY_JH_CNT"));
		String GY_WR_CNT = StringUtil.convertNull(rsTgData.getString(i, "GY_WR_CNT"));
		String JM_JH_CNT = StringUtil.convertNull(rsTgData.getString(i, "JM_JH_CNT"));
		String JM_WR_CNT = StringUtil.convertNull(rsTgData.getString(i, "JM_WR_CNT"));
		String PJ_JH_CNT = StringUtil.convertNull(rsTgData.getString(i, "PJ_JH_CNT"));
		String PJ_WR_CNT = StringUtil.convertNull(rsTgData.getString(i, "PJ_WR_CNT"));
		
		sCoreChart1 = sCoreChart1 + "[\""+HOESA_NAM +"\", " +GY_JH_CNT+", " +GY_WR_CNT+", " +JM_JH_CNT+", " +JM_WR_CNT+", " +PJ_JH_CNT+", " +PJ_WR_CNT+", \"\"],\n";
	}
}
%>
<script type="text/javascript" src="/air-lms/_js/www.gstatic.com/charts/loader.js"></script>
	<script type="text/javascript">
		google.charts.load("current", {packages:["corechart"]});
		google.charts.setOnLoadCallback(drawChart1);
		
		function drawChart1() {
		   	var data1 = google.visualization.arrayToDataTable([
				["회사", "계약 진행", "계약 완료", "자문 진행", "자문 완료", "프로젝트 진행", "프로젝트 완료", { role: "style" }], 
				<%=sCoreChart1 %>
			]);
			
			var view1 = new google.visualization.DataView(data1);
			view1.setColumns([0, 1, 2, 3, 4, 5, 6]);
			
			var options1 = {
				title: "",
				sliceVisibilityThreshold: 0, 
				width: 1000,
				height: 600,
				bar: { groupWidth: "99%" }
				//legend: { position: "none" },   
			};
			
			//var chart1 = new google.visualization.BarChart(document.getElementById("CoreChart1"));
			var chart1 = new google.visualization.ColumnChart(document.getElementById('CoreChart1'));
			chart1.draw(view1, options1);
		}
	</script>
<div id="CoreChart1" style="position:static;"></div>
 --%>