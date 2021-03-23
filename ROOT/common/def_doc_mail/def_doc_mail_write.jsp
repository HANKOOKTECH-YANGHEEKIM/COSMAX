<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>

<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap searchMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= searchMap.getString(CommonConstants.PAGE_NO);
	
	String munseo_seosig_no 		= searchMap.getString("munseo_seosig_no"); 
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults STU_MAS 				= resultMap.getResult("STU_MAS");
	BeanResultMap stuMap = new BeanResultMap();
	if(STU_MAS != null && STU_MAS.getRowCount() > 0){
		stuMap.putAll(STU_MAS.getRowResult(0));
	}
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	String docStuStr	= "|--선택--^A|결재완료^I|결재중^F|결재요청^P|상태처리^S|처리^R|반려";
%>
<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */	
function goList(frm) {		
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_GOLIST",siteLocale)%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();	
	}	
}

/**
 * 저장
 */	
var doSubmit = function(frm) {
	
	if(chkValidate()){
		
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",$(frm).serialize(), function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			DRAW.init();
		});
	}
}
var chkValidate = function(){
	/* 
	if($("#sms_use_yn0").is(":checked")){
		if($("#sms_type_cd").val() == ""){
			alert("SMS 발송여부가 Yes일때는 SMS유형은 필수 선택입니다.");
			return false;
		}
		if($("#sms_message").val() == ""){
			alert("SMS 발송여부가 Yes일때는 SMS 메시지는 필수 입력입니다.");
			return false;
		}
	}
	 */
	return true;
}
//기본처리 ajax는 공통으로 구현(저장은 제외)
var getAjaxData = function(mail_uuid,modeCd,callback){
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, async: true
		, cache: false
		, data: {"AIR_ACTION":"SYS_DEF_DOC_MAIL","AIR_MODE":modeCd,"STU_UID":"<%=stuMap.getString("STU_UID")%>","mail_uuid":mail_uuid}
		, dataType: "json"
	}).done(function(data){
		callback(data);
	}).fail(function(){
		alert("처리중 에러가 발생 하였습니다.");
	});
}
var DRAW_FN = function(){
	var self = this;
	this.init = function(){
		self.initLeftArea();
		self.initRightArea();
	}
	this.initLeftArea = function(){
		getAjaxData('','JSON_LIST',self.drawToLeftStruct);
	}
	//상세내용초기화
	this.initRightArea = function(){
		$("#event_code").val("");
		$("#event_name").val("");
		$("#event_name").val("");
		$("input:radio[name=sms_use_yn]").eq(0).prop("checked", false);
		$("input:radio[name=sms_use_yn]").eq(1).prop("checked", true);
		$("#sms_type_cd").val("");
		$("#sms_message").val("");
// 		EVENT.setSmsUse();
		$("#mail_uuid").val("");
		$("#susin_role").val("C_EUIROE");
		$("#susin_role_td").html("");
		$("#susin_user_td").html("");
		$("#chamjo_role").val("C_EUIROE");
		$("#chamjo_role_td").html("");
		$("#chamjo_user_td").html("");
		$("#mail_title").val("");
		$("#mail_content").val("");
		$("#mail_title").removeAttr("disabled");
		$("#mail_content").removeAttr("disabled");
		$("#doc_title_use_yn").prop("checked",false);
		$("#doc_content_use_yn").prop("checked",false);
		
	}
	//이벤트 리스트그리기
	this.drawToLeftStruct = function(data){
		var jsonData = data.rows;
		console.log(JSON.stringify(jsonData));
		$("#event_tbody").html("");
		if(jsonData){
			for(var i = 0; i< jsonData.length; i++){
				var title = jsonData[i].DOC_STU_NM +":"+ jsonData[i].SUSIN_ROLE_NM;
				if(title == ""){
					title = jsonData[i].DOC_STU_NM +":"+jsonData[i].SUSIN_USER_NM;
				}
		   		var htmlTxt = "<div id=\""+jsonData[i].MAIL_UUID+"\">"+title+"<input type=\"hidden\" name=\"role_val\" value=\""+jsonData[i].login_id+"\">"+imgTxt+"</div>";
				var imgTxt = "<img src=\"/common/_images/close_popup.gif\" style=\"cursor:pointer;vertical-align:baseline\" onclick=\"javascript:EVENT.removeEvent('"+jsonData[i].MAIL_UUID+"');\">";
				var trE = document.createElement("tr");
				var tdE = document.createElement("td");
				$(tdE).css("text-align","left");
				var aE = document.createElement("a");
				aE.href="javascript:void(0)";
				$(aE).attr("onClick","DRAW.setDetail('"+jsonData[i].MAIL_UUID+"')");
				$(aE).text(title);
				
				$(tdE).append(aE);
				$(tdE).append(imgTxt);
				$(trE).append(tdE);
		   		$("#event_tbody").append($(trE));
		    }
		}
	}
	//수신자 참조지 구조생성
	this.drawToSuChamStruct = function(type,gbn,val,nam){
		//초기화
		$("#"+type+"_"+gbn+"_td").html("");
		
		if(val == "")return;
		if(nam == "")return;
		var arrVal = val.split(",");
		var arrNam = nam.split(",");
		for(var i=0; i < arrVal.length; i++){
			var selVal = arrVal[i];
			var selTxt = arrNam[i];
			var imgTxt = "<img src=\"/common/_images/close_popup.gif\" style=\"cursor:pointer;vertical-align:baseline\" onclick=\"javascript:$(this).parent().remove();\">";
			var htmlTxt = "<div>"+selTxt+"<input type=\"hidden\" name=\""+type+"_"+gbn+"_val\" value=\""+selVal+"\"><input type=\"hidden\" name=\""+type+"_"+gbn+"_nam\" value=\""+selTxt+"\">"+imgTxt+"</div>";
			$("#"+type+"_"+gbn+"_td").append(htmlTxt);
		}
	}
	this.drawToDetail = function(jsonData){
		var data = jsonData.rows;
		self.initRightArea();
		$("#mail_uuid").val(data[0].MAIL_UUID);
// 		$("#event_code").val(data[0].EVENT_CODE);
// 		$("#event_name").val(data[0].EVENT_NAME);
// 		if(data[0].SMS_USE_YN == "Y"){
// 			$("input:radio[name=sms_use_yn]").eq(0).prop("checked", true);
// 			$("input:radio[name=sms_use_yn]").eq(1).prop("checked", false);
// 			$("#sms_type_cd").val(data[0].SMS_TYPE_CD);
// 			$("#sms_message").val(data[0].SMS_MESSAGE);
// 			EVENT.setSmsUse(data[0].SMS_USE_YN);
// 		}else{
// 			$("input:radio[name=sms_use_yn]").eq(0).prop("checked", false);
// 			$("input:radio[name=sms_use_yn]").eq(1).prop("checked", true);
// 			$("#sms_type_cd").val("");
// 			$("#sms_message").val("");
// 			EVENT.setSmsUse(data[0].SMS_USE_YN);
// 		}
		$("#doc_stu").val(data[0].DOC_STU);
		$("#mail_title").val(data[0].MAIL_TITLE);
		$("#mail_content").val(data[0].MAIL_CONTENT);
		if(data[0].DOC_TITLE_USE_YN == "Y"){
			$("#doc_title_use_yn").prop("checked",true);
			EVENT.setDisable($("#doc_title_use_yn"), "title");
		}
		if(data[0].DOC_CONTENT_USE_YN == "Y"){
			$("#doc_content_use_yn").prop("checked",true);
			EVENT.setDisable($("#doc_content_use_yn"), "content");
		}
		self.drawToSuChamStruct('susin','role',data[0].SUSIN_ROLE_CD,data[0].SUSIN_ROLE_NM);
		self.drawToSuChamStruct('susin','user',data[0].SUSIN_USER_CD,data[0].SUSIN_USER_NM);
		self.drawToSuChamStruct('chamjo','role',data[0].CHAMJO_ROLE_CD,data[0].CHAMJO_ROLE_NM);
		self.drawToSuChamStruct('chamjo','user',data[0].CHAMJO_USER_CD,data[0].CHAMJO_USER_NM);
		
	}
	this.setDetail = function(defNo){
		getAjaxData(defNo,'JSON_LIST',self.drawToDetail);
	}
}

var EVENT_FN = function(){
	var self = this;
	
	this.openUserselect = function(type){
		var userObj = $("#"+type+"_user_td").find("input:hidden");
		var userIds = "";
		$(userObj).each(function(i){
			if(i > 0)userIds += ",";
			userIds += $(this).val();
		});
		//지정 사용자 셋팅
		var defaultUser = userIds
		var callback = "EVENT.addUser"+type;
		var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECTS_DTREE";
		url += "&callbackFunction="+ escape(callback); //XSS필터링 통과를 위해 escape 적용!
		url += "&defaultUser="+defaultUser
		url += "&groupTypeCodes=IG"
		url += "&userType=user"
	        	
		window.open(url, 'popupGroupSelects', "width=1024,height=600,scrollbars=yes,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no");
	}
	/**
	 *	수신 사용자 추가
	 */
	this.addUsersusin = function(data) {
		//초기화
		$("#susin_user_td").html("");
	    var jsonData = JSON.parse(data);
	  	var imgTxt = "<img src=\"/common/_images/close_popup.gif\" style=\"cursor:pointer;vertical-align:baseline\" onclick=\"javascript:$(this).parent().remove();\">";
	    for(var i = 0; i< jsonData.length; i++){
	   		var htmlTxt = "<div>"+jsonData[i].name_<%=siteLocale.toLowerCase()%>+"<input type=\"hidden\" name=\"susin_user_val\" value=\""+jsonData[i].login_id+"\"><input type=\"hidden\" name=\"susin_user_nam\" value=\""+jsonData[i].name_<%=siteLocale.toLowerCase()%>+"\">"+imgTxt+"</div>";
	   		$("#susin_user_td").append(htmlTxt);
	    }
	}

	/**
	 * 참조 사용자 추가
	 */
	this.addUserchamjo = function(data){
		$("#chamjo_user_td").html("");
		var jsonData = JSON.parse(data);
		var imgTxt = "<img src=\"/common/_images/close_popup.gif\" style=\"cursor:pointer;vertical-align:baseline\" onclick=\"javascript:$(this).parent().remove();\">";
	   	for(var i = 0; i< jsonData.length; i++){
			var htmlTxt = "<div>"+jsonData[i].name_<%=siteLocale.toLowerCase()%>+"<input type=\"hidden\" name=\"chamjo_user_val\" value=\""+jsonData[i].login_id+"\"><input type=\"hidden\" name=\"chamjo_user_nam\" value=\""+jsonData[i].name_<%=siteLocale.toLowerCase()%>+"\">"+imgTxt+"</div>";
			$("#chamjo_user_td").append(htmlTxt);
	   	}
	}
	
	/**
	 * 역할 추가
	 */
	this.addRole = function(type){
		var selVal = $("#"+type+"_role").val();
		if(self.chkRoll(type,selVal)){
			var selTxt = $("#"+type+"_role option:selected").text();
			var imgTxt = "<img src=\"/common/_images/close_popup.gif\" style=\"cursor:pointer;vertical-align:baseline\" onclick=\"javascript:$(this).parent().remove();\">";
			var htmlTxt = "<div>"+selTxt+"<input type=\"hidden\" name=\""+type+"_role_val\" value=\""+selVal+"\"><input type=\"hidden\" name=\""+type+"_role_nam\" value=\""+selTxt+"\">"+imgTxt+"</div>";
			$("#"+type+"_role_td").append(htmlTxt);
		}
	}
	//같은역할 체크
	this.chkRoll = function(type,val){
		var obj = $("#"+type+"_role_td").find("input:hidden");
		var bool = true;
		$(obj).each(function(){
			if($(this).val() == val){
				bool = false;
			}
		})

		return bool;
	}
	//이벤트명 셋팅
	this.setEventNm = function(){
		$("#event_name").val($("#event_code :selected").text());
	}
	//SMS 타입명
	this.setSmsNm = function(){
		$("#sms_name").val($("#sms_type_cd :selected").text());
	}
	
	//SMS 사용셋팅
	this.setSmsUse = function(val){
		if("Y"== val){
			$("#sms_type").show();
			$("#smsMessage").show();
		}else{
			$("#sms_type").hide();
			$("#smsMessage").hide();
		}
	}
	
	this.removeEvent = function(defNo){
		if(confirm("삭제하시겠습니까?")){
			getAjaxData(defNo,'DELETE_PROC',function(){
				alert("정상적으로 삭제 되었습니다.");
				DRAW.initLeftArea();
				
			});
		}
	}
	
	this.setDisable = function(obj,id){
		if($(obj).is(":checked")){
			$("#mail_"+id).attr("disabled","disabled");
		}else{
			$("#mail_"+id).removeAttr("disabled");
		}
	}
}



var DRAW = new DRAW_FN();
var EVENT = new EVENT_FN();
$(function(){
	DRAW.init();
});
</script>


<table class="basic">
	<tr>
		<th class="th4">법무구분</th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td4"><%=stuMap.getString("STU_GBN_NM")%></td>		
		<th class="th4">기본상태명</th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td4"><%=stuMap.getString("STU_BASE_NM")%></td>		
	</tr>
	<tr>
		<th class="th4">상태코드</th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td4"><%=stuMap.getString("STU_ID")%></td>		
		<th class="th4">처리형식</th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td4"><%=stuMap.getString("PROC_GBN")%></td>		
	</tr>
</table>
<br><br>
<table class="basic">
	<caption>수신 메일 설정</caption>
	<tr>
		<th style="width:25%">
			지정메일
		</th>
		<th style="width:75%">
			상세내용
			<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="DRAW.initRightArea();">초기화</a></span>
		</th>
	</tr>
	<tr>
		<td style="width:20%;vertical-align: top;">
			<table class="basic">
			<tbody id="event_tbody">
			</tbody>
			</table>
		</td>
		<td style="width:80%">
		<form name="form1" method="post">
			<input type="hidden" name="stu_uid" value="<%=stuMap.getString("STU_UID")%>" />
			<input type="hidden" name="stu_id" value="<%=stuMap.getString("STU_ID")%>" />
			<input type="hidden" name="mail_uuid" id="mail_uuid" value="" />
			<table class="basic">
				<tr>
					<th class="th4">이벤트</th>
					<td>
						<%=HtmlUtil.getSelect(request, true, "doc_stu" , "doc_stu", docStuStr, "", "onChange=\"$('#mail_uuid').val('');\"") %>
					</td>
				</tr> 
				<tr>
					<th class="th4">수신자선택</th>
					<td>
						<table class="basic">
							<tr>
								<th class="th4">역할추가</th>
								<td class="td4">
									<select name="susin_role" id="susin_role">
<!-- 										<option value="BALSINJA">발신자</option> -->
<!-- 										<option value="SUSINJA">수신자</option> -->
										<option value="EUIROE">의뢰자</option>
										<option value="EUIROE_CHIEF">의뢰부서 팀장</option>
										<option value="NEXT_W">다음결재자</option>
		                                <option value="BAEDANG">법무 배당권자</option>
		                                <option value="DAMDANG">법무 담당자</option>
		                                <option value="CHONGMU">인감 담당자</option>
		                                <option value="CHAMJO">모든참조자</option>
<!-- 		                                <option value="DAMDANG_CHIEF">법무부서 팀장</option> -->
<!-- 		                                <option value="CHONGMUGYEOL">총무 결재자</option> -->
									</select>
									<span class="ui_btn small icon"><span class="add"></span><a href="javascript:EVENT.addRole('susin');">추가</a></span>
								</td>
								<th class="th4">사용자추가</th>
								<td class="td4">
									<span class="ui_btn small icon" id="USER_SUSIN"><span class="search"></span><a id="user" href="javascript:EVENT.openUserselect('susin');">수신자선택</a></span>
								</td>
							</tr>
						</table>	
					</td>
				</tr>
				<tr>
					<th class="th4">수신자</th>
					<td>
						<table class="basic">
							<tr>
								<th class="th4">역할</th>
								<td class="td4" id="susin_role_td">
								</td>
								<th class="th4" >사용자</th>
								<td class="td4" id="susin_user_td"></td>
							</tr>
						</table>	
					</td>
				</tr>
				<tr>
					<th class="th4">참조자선택</th>
					<td>
						<table class="basic">
							<tr>
								<th class="th4">역할추가</th>
								<td class="td4">
									<select name="chamjo_role" id="chamjo_role">
										<option value="EUIROE">의뢰자</option>
										<option value="EUIROE_CHIEF">의뢰부서 부서장</option>
										<option value="NEXT_W">다음처리자(결재자)</option>
		                                <option value="BAEDANG">법무 배당권자</option>
		                                <option value="DAMDANG">법무 담당자</option>
		                                <option value="CHONGMU">인감 담당자</option>
									</select>
									<span class="ui_btn small icon"><span class="add"></span><a href="javascript:EVENT.addRole('chamjo');">추가</a></span>
								</td>
								<th class="th4">사용자추가</th>
								<td class="td4">
									<span class="ui_btn small icon"><span class="search"></span><a id="user" href="javascript:EVENT.openUserselect('chamjo');">수신자선택</a></span>
								</td>
							</tr>
						</table>	
					</td>
				</tr>
				<tr>
					<th class="th4">참조자</th>
					<td>
						<table class="basic">
							<tr>
								<th class="th4">역할</th>
								<td class="td4" id="chamjo_role_td">
								</td>
								<th class="th4" >사용자</th>
								<td class="td4" id="chamjo_user_td"></td>
							</tr>
						</table>	
					</td>
				</tr>
				<tr id="smsMessage" style="display: none;">
					<th>SMS 메시지</th>
					<td>
						<input type="text" name="sms_message" id="sms_message" class="text width_max" value=""/>
					</td>
				</tr>
				<tr>
					<th>메일제목</th>
					<td>
						<input type="checkbox" name="doc_title_use_yn" id="doc_title_use_yn" value="Y" onclick="EVENT.setDisable(this, 'title')"/>문서 제목내용으로 대체
						<input type="text" name="mail_title" id="mail_title" class="text width_max" value=""/>
					</td>
				</tr>
				<tr>
					<th>메일내용</th>
					<td>
<!-- 						<input type="checkbox" name="doc_content_use_yn" id="doc_content_use_yn" value="Y" onclick="EVENT.setDisable(this,'content')"/>문서 내용으로 대체 -->
						<textarea name="mail_content" id="mail_content" rows="10" class="text width_max"></textarea>
					</td>
				</tr>
				<tr>
					<th>링크사용여부</th>
					<td>
					</td>
				</tr>
			</table>
		</form>
		<div class="buttonlist">
			<div class="right">
				<span class="ui_btn medium icon"><span class="confirm"></span><input type="button" name="btnCol"  value="<%=StringUtil.getLocaleWord("B.저장", siteLocale) %>" onclick="doSubmit(document.form1)" /></span>
			</div>
		</div>	
		</td>
	</tr>
</table>
<br><br>

<div class="buttonlist">
	<div class="right">
		<span class="ui_btn medium icon"><span class="list"></span><input type="button" name="btnCol"  value="<%=StringUtil.getLocaleWord("B.CLOSE", siteLocale) %>" onclick="window.close();" /></span>
	</div>
</div>	
