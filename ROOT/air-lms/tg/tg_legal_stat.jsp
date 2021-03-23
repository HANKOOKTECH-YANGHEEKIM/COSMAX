<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="java.util.Calendar" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);	

	String menuNm					= requestMap.getString(siteLocale);
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode	= resultMap.getString(CommonConstants.MODE_CODE);
		
	SQLResults rsTgData	= resultMap.getResult("LEGAL_STAT");
	
	//-- 코드정보 문자열 셋팅
	String 전체 = StringUtil.getLocaleWord("L.CBO_ALL",siteLocale);
	String 진행 = StringUtil.getLocaleWord("L.요청",siteLocale);
	String 완료 = StringUtil.getLocaleWord("L.완료",siteLocale);
	String 계류 = StringUtil.getLocaleWord("L.요청",siteLocale);
	String 종결 = StringUtil.getLocaleWord("L.완료",siteLocale);
	
	String jsonDetailUrl = "/ServletController"
		        + "?AIR_ACTION=LMS_MAIN"  
		        + "&AIR_MODE=JSON_DAMDANG_STAT"
		        + "&DAMDANG_ID=";
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm%>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form name="form1" method="post">	
<input type="hidden" name="<%=siteLocale %>" value="<%=menuNm%>" />
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
<input type="hidden" name="DAMDANG_ID" />
<input type="hidden" name="GUBUN" />
<input type="hidden" name="GUBUN_ALL" />
<input type="hidden" name="STAT" /> 

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
						<col style="width:14%;" />
						<col style="width:10%;" />
						<col style="width:14%;" />
						<col style="width:auto;" />
					</colgroup>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.기간", siteLocale) %></th>
						<td>
						<select name="schYear" data-type="search" style="width:70px;">
							<%=HtmlUtil.getSelectboxCalendar("YEAR", 2018, -1, requestMap.getString("SCHYEAR")) %>
						</select>
						<select name="schMonth" data-type="search" style="width:50px;">
							<%=HtmlUtil.getSelectboxCalendar("MONTH", 1, 12, requestMap.getString("SCHMONTH")) %>
						</select>
						</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
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
		<div class="left" style="color:red; text-align:left;">
			<%=StringUtil.getLocaleWord("M.법무팀업무현황계약기준",siteLocale)%><br />
			<%=StringUtil.getLocaleWord("M.법무팀업무현황소송기준",siteLocale)%>
		</div>
		<div class="right">
	    	<script>
			/*
			 * 엑셀다운로드
			 */
			function doExcelDown(frm){
				frm.action = "/ServletController";
				frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
				frm.<%=CommonConstants.MODE_CODE%>.value = "LEGAL_STAT_EXCEL";
				frm.target = "airBackgroundProcessFrame";
				frm.submit();
			} 
			</script>
			<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>		
		</div>
		<div class="right">
		</div>								
	</div>
	<table class="basic">
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
			<th rowspan="2"  style="text-align:center"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
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
			String HOESA_NAM = rsTgData.getString(i, "HOESA_NAM");
			int iGROUP_COUNT = Integer.parseInt(rsTgData.getString(i, "GROUP_COUNT"));
			String DAMDANG_NAM = rsTgData.getString(i, "NAME_"+siteLocale);
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
			chartData+="{ DAMDANG:'"+DAMDANG_NAM+"',GY_JH_CNT:"+GY_JH_CNT+",JM_JH_CNT:"+JM_JH_CNT+",JM_WR_CNT:"+JM_WR_CNT+"}";
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
			<td><%=DAMDANG_NAM %></td>
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
var frm = document.form1;

function doReset(frm){ 
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale) %>")) {
	    $("#schYear").val("<%=Calendar.getInstance().get(Calendar.YEAR) %>");
	}
}

function doSearch(frm){
	frm.action = "/ServletController";
	frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
	frm.<%=CommonConstants.MODE_CODE%>.value = "<%=modeCode%>";
	frm.target = "_self";
	frm.submit();
}
/**
 * onload event handler
 */
$(document).ready(function() {
});
</script>
<%-- 
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxdraw.js"></script>   
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxchart.core.js"></script>  
    <script type="text/javascript">
        $(document).ready(function () {
            // prepare chart data as an array
            var  sampleData = [<%=chartData%>];
            // prepare jqxChart settings
            var settings = {
                title: "<%=StringUtil.getLocaleWord("L.법무_검토소요기간",siteLocale) %>",
                description: "",
				enableAnimations: true,
                showLegend: true,
                padding: { left: 5, top: 5, right: 5, bottom: 5 },
                titlePadding: { left: 90, top: 0, right: 0, bottom: 10 },
                source: sampleData,
                xAxis:
                    {
                        dataField: 'DAMDANG',
                        showGridLines: true
                    },
                colorScheme: 'scheme01',
                seriesGroups:
                    [
                        {
                            type: 'column',
                            columnsGapPercent: 10,
                            seriesGapPercent: 0,
                            valueAxis:
                            {
                                unitInterval: <%=(iLimitRow+10)/5%>,
                                minValue: 0,
                                maxValue: <%=iLimitRow+10%>,
                                displayValueAxis: true,
                                description: '건수',
                                axisSize: 'auto',
                                tickMarksColor: '#888888'
                            },
                            series: [
                                    { dataField: 'GY_JH_CNT', displayText: '<%=계약+진행%>'},
                                    { dataField: 'GY_WR_CNT', displayText: '<%=계약+완료%>'},
                                    { dataField: 'JM_JH_CNT', displayText: '<%=자문+진행%>'},
                                    { dataField: 'JM_WR_CNT', displayText: '<%=자문+완료%>'},
                                    { dataField: 'SS_JH_CNT', displayText: '<%=소송+계류%>'},
                                    { dataField: 'SS_WR_CNT', displayText: '<%=소송+종결%>'},
                                    { dataField: 'BJ_JH_CNT', displayText: '<%=분쟁+진행%>'},
                                    { dataField: 'BJ_WR_CNT', displayText: '<%=분쟁+완료%>'}, 
                                    
                                ]
                        }
                    ]
            };
            
            // setup the chart
            $('#jqxChart').jqxChart(settings);
        });
    </script> 
    <br />
    <br />
<div style='height: 300px; width: 100%;'>
    <div id='host' style="margin: 0 auto; width:100%; height:300px;">
	<div id='jqxChart' style="width:100%; height:300px; position: relative; left: 0px; top: 0px;">
	</div>
</div> 
--%>
<%--
<script type="text/javascript">
function goListPopup(  id, gubun, stat, gubunAll){
	var url = "/ServletController";
	
	url += "?AIR_ACTION=LMS_TG";
	url += "&AIR_MODE=POPUP_LEGAL_LIST";
	url += "&DAMDANG_ID="+id;
	url += "&GUBUN="+gubun;
	url += "&GUBUN_ALL="+gubunAll;
	url += "&STAT="+stat;
	url += "&schDateFrom="+$("#schDateFrom").val();
	url += "&schDateTo="+$("#schDateTo").val();
	
	//airCommon.openWindow(url, "1024", "370", "POPUP_VIEW", "yes", "yes", ""); 
}
</script>
<%
//Chart를 위한 작업
String sCoreChart1 = "";

if(rsTgData != null && rsTgData.getRowCount() > 0){
	for(int i=0; i< rsTgData.getRowCount(); i++){
		String DAMDANG_NAM = rsTgData.getString(i, "NAME_"+siteLocale);
		String GY_JH_CNT = rsTgData.getString(i, "GY_JH_CNT");
		String GY_WR_CNT = rsTgData.getString(i, "GY_WR_CNT");
		String JM_JH_CNT = rsTgData.getString(i, "JM_JH_CNT");
		String JM_WR_CNT = rsTgData.getString(i, "JM_WR_CNT");
		String SS_JH_CNT = rsTgData.getString(i, "SS_JH_CNT");
		String SS_WR_CNT = rsTgData.getString(i, "SS_WR_CNT");
		
		sCoreChart1 = sCoreChart1 + "[\""+DAMDANG_NAM +"\", " +GY_JH_CNT+", " +GY_WR_CNT+", " +JM_JH_CNT+", " +JM_WR_CNT+", " +SS_JH_CNT+", " +SS_WR_CNT+", " +", \"\"],\n";
	}
}
%>
<script type="text/javascript" src="/air-lms/_js/www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
		google.charts.load("current", {packages:["corechart"]});
		google.charts.setOnLoadCallback(drawChart1);
		
		function drawChart1() {
		   	var data1 = google.visualization.arrayToDataTable([
				["이름", "계약 진행", "계약 완료", "자문 진행", "자문 완료", "소송 진행", "소송 완료", { role: "style" }], 
				<%=sCoreChart1 %>
			]);
			
			var view1 = new google.visualization.DataView(data1);
			view1.setColumns([0, 1, 2, 3, 4, 5, 6, 7, 8]);
			
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