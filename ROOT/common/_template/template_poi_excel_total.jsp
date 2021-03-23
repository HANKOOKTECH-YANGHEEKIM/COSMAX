<%@page import="com.emfrontier.air.common.util.FileUtil"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.StringUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%      
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = CommonProperties.getSystemDefaultLocale();
	
	if (loginUser != null) {
		siteLocale = loginUser.getSiteLocale();
	}

	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults res = resultMap.getResult("TOTAL_LIST");
	
	String file_save_name = "";
	file_save_name = FileUtil.escapeFilename("송무사건일람표") + ".xls";		
	file_save_name = FileUtil.getAttachmentFilename(request, file_save_name, "UTF-8");	


	int spRawCount  = 0;

	if(res == null) {
	} else {

		if(res != null) {
			spRawCount = res.getRowCount();
		}
	}
%>                                  
<%
	if ( spRawCount > 65000 ) {
%>
		<SCRIPT type="text/javascript">
			alert ( "※ 엑셀형식은 65,000건 이상 \n 화면지원이 불가능합니다." );
			window.close();
		</SCRIPT>
<%		
	} else {
		
		response.setContentType("application/vnd.ms-excel; charset=utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=" + file_save_name);
		response.setHeader("Content-첨부설명", "JSP Generated Data");
		
	}
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<STYLE type=text/css>

TR.Line1{background:#F2F2F2}
TR.Line2{background:#FFFFFF}
TR.Dgn_Line1{background:#FFF0E1}
TR.Dgn_Line2{background:#FFE8D2}
TR.trademark_Line1{background:DAEAF7}
TR.trademark_Line2{background:F3F8FC}
TR.Plot_Line1{background:F5EBEE}
TR.Plot_Line2{background:F2E5E9}
TR.cost_Line1{background:#E1F4F6}
TR.cost_Line2{background:#D6F1F2}
TR.Over{background:#F5F0D7}
TR.analysis_Line1{background:#FFFFFF}
TR.analysis_Line2{background:#F3F6F9}

BODY
{
    SCROLLBAR-3DLIGHT-COLOR: #cfcfcf;
    SCROLLBAR-ARROW-COLOR: #ffffff;
    SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
    SCROLLBAR-BASE-COLOR: #cfcfcf
    SCROLLBAR-FACE-COLOR: #cfcfcf;
}

.margin_comment1{ padding-top:3px;padding-left:0px; padding-right:0px; padding-bottom:3px; font-family:"돋움체"; font-size:16px;}
.margin_comment2{ padding-top:3px;padding-left:0px; padding-right:0px; padding-bottom:3px; font-family:"돋움체"; font-size:12px; color:#2D87AD; background-color:#E4E5F2;}
.margin_comment3{ padding-top:3px;padding-left:0px; padding-right:0px; padding-bottom:3px; font-family:"돋움체"; font-size:12px; color:#484848; background-color:#FFFFFF;}
.margin_comment4{ padding-top:0px;padding-left:0px; padding-right:0px; padding-bottom:0px; font-family:"돋움체"; font-size:12px; color:#484848; background-color:#FFFFFF;}
.tdR 
{
	border-right: 1 solid #FFFFFF;
	color:font-family: ""; 
	font-size: 12px; 
	color: #3E3E3E;
	text-align:center;
}
.tdRB
{
	border-right: 1 solid #FFFFFF; border-bottom: 1 solid #FFFFFF;
	color:font-family: ""; 
	font-size: 12px; 
	color: #3E3E3E;
	text-align:center;
}
.tdB
{
	border-bottom: 1 solid #FFFFFF;
	color:font-family: ""; 
	font-size: 12px; 
	color: #3E3E3E;
	text-align:center;
}
.tdB2
{
	border-bottom: 1 solid #FFFFFF;
	color:font-family: ""; 
	font-size: 12px; 
	color: #3E3E3E;
	padding-left:5px;
}
.td
{
	color:font-family: ""; 
	font-size: 12px; 
	color: #3E3E3E;
	text-align:center;
}
TD
{
    FONT-SIZE: 9pt;
    COLOR: #444444;
    FONT-FAMILY: Arial
}

</STYLE>

<SCRIPT type="text/javascript" src="/common/js/Cmcommon.js" type="text/JavaScript"></script>
<script type="text/javascript" src="/common/js/javascript.js"></script>

</head>

<table width="800" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25" align="center" colspan="15" class="margin_comment1"><strong>송 무 사 건 일 람 표</strong></td>
	</tr>
</table>
<br>
	
<table width="800" border="1" cellpadding="0" cellspacing="1" bgcolor="CDCDCD">
	<tr align="center">
		<th rowspan="2">연번</th>
		<th rowspan="2">구분</th>
		<th rowspan="2">사건명</th>
		<th colspan="2">당사자</th>
		<th colspan="5">사건일반</th>
		<th colspan="2">사건이력</th>
		<th rowspan="2"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
		<th rowspan="2">위임(협력)업체<br>(단위:만원)</th>
		<th rowspan="2">비고</th>		
	</tr>
	<tr align="center">
		<th>원고(채권자)</th>
		<th>피고(채무자)</th>
		<th>관할법원</th>
		<th>사건번호</th>
		<th>소재제소일</th>
		<th>소가</th>
		<th>심급</th>
		<th>관련사건</th>
		<th>기일정보</th>
		
	</tr>
	
	<%
	int cnt = 1;
	
		if(res != null){
			for(int i=0;i<res.getRowCount();i++){
				
				
				
				String gubun = StringUtil.convertNull(res.getString(i, "GUBUN"));
				String title = StringUtil.convertNull(res.getString(i, "TITLE"));
				String weongo = StringUtil.convertNull(res.getString(i, "WEONGO"));
				String pigo = StringUtil.convertNull(res.getString(i, "PIGO"));
				String beobweon_nam = StringUtil.convertNull(res.getString(i, "BEOBWEON_NAM"));
				String sageon_no = StringUtil.convertNull(res.getString(i, "SAGEON_NO"));
				String sojegi_dte = StringUtil.convertNull(res.getString(i, "SOJEGI_DTE"));
				String soga = StringUtil.convertNull(res.getString(i, "SOGA"));
				String sim_nam = StringUtil.convertNull(res.getString(i, "SIM_NAM"));
				String[] share_doc = res.getString(i, "SHARE_DOC").split(",");
				String[] giil_info = StringUtil.convertNull(res.getString(i, "GIIL_INFO")).split(",");
				String damdang_nam = StringUtil.convertNull(res.getString(i, "DAMDANG_NAM"));
				String[] biyong = StringUtil.convertNull(res.getString(i, "BIYONG")).split(",");
				String bigo = StringUtil.convertNull(res.getString(i, "BIGO"));
				
				
				//관련사건
				String[] temp_Share_Doc_Array = new String[30];
				for(int a=0;a<temp_Share_Doc_Array.length;a++){
					temp_Share_Doc_Array[a] = "empty";
				}
				int cnt1 = 0;
				for(int s1=1;s1<share_doc.length;s1++){
					
					if(s1==1){
						temp_Share_Doc_Array[0] = share_doc[1];
						cnt1 ++;
					}else{
						boolean flag = true;
						for(int s2=0;s2<temp_Share_Doc_Array.length;s2++){
							if(temp_Share_Doc_Array[s2].equals(share_doc[s1])){
								flag = false;
							}
						}
							if(flag){
								temp_Share_Doc_Array[cnt1] = share_doc[s1];
								cnt1 ++;					
							}
					}
					
				}//for end
				
				
				//기일정보
				String[] temp_giil_info_Array = new String[30];
				for(int a=0;a<temp_giil_info_Array.length;a++){
					temp_giil_info_Array[a] = "empty";
				}
				int cnt2 = 0;
				for(int s1=1;s1<giil_info.length;s1++){
					
					if(s1==1){
						temp_giil_info_Array[0] = giil_info[1];
						cnt2 ++;
					}else{
						boolean flag = true;
						for(int s2=0;s2<temp_giil_info_Array.length;s2++){
							if(temp_giil_info_Array[s2].equals(giil_info[s1])){
								flag = false;
							}
						}
							if(flag){
								temp_giil_info_Array[cnt2] = giil_info[s1];
								cnt2++;					
							}
					}
					
				}//for end
				
				
				
				
				//위힘(협력)업체
				String[] temp_Biyong_Array = new String[30];
				for(int a=0;a<temp_Biyong_Array.length;a++){
					temp_Biyong_Array[a] = "empty";
				}
				int cnt3 = 0;
				for(int s1=1;s1<biyong.length;s1++){
					
					if(s1==1){
						temp_Biyong_Array[0] = biyong[1];
						cnt3 ++;
					}else{
						boolean flag = true;
						for(int s2=0;s2<temp_Biyong_Array.length;s2++){
							if(temp_Biyong_Array[s2].equals(biyong[s1])){
								flag = false;
							}
						}
							if(flag){
								temp_Biyong_Array[cnt3] = biyong[s1];
								cnt3++;					
							}
					}
					
				}//for end
				
				
				
				
				
				%>
					<tr align="center" class="line1">
						<td><%=cnt%></td>
						<td><%=gubun%></td>
						<td><%=title%></td>
						<td><%=weongo%></td>
						<td><%=pigo%></td>
						<td><%=beobweon_nam%></td>
						<td><%=sageon_no%></td>
						<td><%=sojegi_dte%></td>
						<td><%=soga%></td>
						<td><%=sim_nam%></td>
						
						<td>
						<%
							for(int r1=0;r1<temp_Share_Doc_Array.length;r1++){
								if(!("empty".equals(temp_Share_Doc_Array[r1]))){
									%>
										<%=temp_Share_Doc_Array[r1]%>
										<br>
									<%
								}
							}
						%>
						</td>
						
						<td>
						<%
							for(int r1=0;r1<temp_giil_info_Array.length;r1++){
								if(!("empty".equals(temp_giil_info_Array[r1])) ){
									if("()".equals(temp_giil_info_Array[r1])){
										temp_giil_info_Array[r1] = "";
									}
									%>
										<%=temp_giil_info_Array[r1]%>
										<br>
									<%
								}
							}
						%>
						</td>
						
						<td><%=damdang_nam%></td>
						
						<td>
						<%
						String[] tit = temp_Biyong_Array[0].split("/");
						if(!("".equals(tit[0]))){
							%>
								- <%=tit[0] %>
								<br>
							<%
						}
						
							for(int r1=0;r1<temp_Biyong_Array.length;r1++){
								if(!("/:".equals(temp_Biyong_Array[r1]))){
									if(!("empty".equals(temp_Biyong_Array[r1])) ){
										if(r1==0){
											%>
												<%=tit[1] %>
												<br>
											<%
										}else{
											String[] tit2 = temp_Biyong_Array[r1].split("/");
											if(tit[0].equals(tit2[0])){
												%>
													<%=tit2[1] %>
													<br>
												<%
											}else{
												%>
													- <%=tit2[0] %>
													<br>
													<%=tit2[1] %>
													<br>
												<%
												tit[0] = tit2[0];
											}
										}
									}
								}
							}
						%>
						</td>
						
						
						<td><%=bigo%></td>
						
					</tr>
				<%
				cnt ++;
			}
		}else{
			%>
				<tr align="center">
					<td colspan="15">데이터가 없습니다</td>
				</tr>
			<%
		}
	%>
</table>
</html>