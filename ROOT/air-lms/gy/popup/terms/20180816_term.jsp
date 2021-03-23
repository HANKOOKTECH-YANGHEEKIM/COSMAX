<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>

<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);
	
	/*
	*	라이오 name은 꼭 접두로 'lmㄴ_pati_'가 붙어야 함.
	*/
%>
<script>
var validation = function(){
	if($("input:radio[name='lms_pati_term_01']:checked").length == 0){
		alert("중도해지 유형을 선택해 주세요.");
		return false;
	}
	if($("input:radio[name='lms_pati_term_02']:checked").length == 0){
		alert("자동연장 유형을 선택해 주세요.");
		return false;
	}
	if($("input:radio[name='lms_pati_term_03']:checked").length == 0){
		alert("손해배상 유형을 선택해 주세요.");
		return false;
	}
	return true;
}
</script>
<h1>&#60;장비투자형 서비스 제공 계약&#62;</h1>
<table class="basic">
	<tr>
		<th style="width:10%">유형</th>
		<td colspan="3">
			<ul>
				<li>서비스 제공계약 중에서, 고객이 당사가 제공하는 서비스를 이용하기 위해서는 특정 장비의 설치가 필요한 계약</li>
				<li>계약 예시: 시내전화서비스, 인터넷전화 서비스, 전국대표번호 서비스 제공 계약 등</li>
			</ul>
		</td>
	</tr>
	<tr>
		<th>거래구조/특성</th>
		<td colspan="3">
			<ul>
				<li>당사는 당사의 비용으로 장비를 설치 후 고객이 지급하는 서비스 이용요금으로 장비 투자금을 회수하고 이익을 창출</li>
				<li>동 계약의 고객은 주로 기업이며, 특정 업무(대기업 사내 망 등)목적으로 서비스를 사용하는 경우가 많아서 서비스 장애발생시 당사가 고객에게 모든 손해를 배상해야 한다면 그 배상액이 계약에서 창출되는 이익보다 커질 우려 有</li>
			</ul>
		</td>
	</tr>
	<tr>
		<th rowspan="3">표준거래조건</th>
		<th style="width:15%;">중도해지 시<br/>손실 보전</th>
		<td>
			<p>고객이 임의로 계약을 중도해지하거나 당사가 고객 귀책사유로 인하여 계약을 해지할 경우, 고객은 <u>장비를 취득가로 매수해야 하고</u><span style="color:red;">(① 장비매수청구권)</span>, <u>해지 전 이용기간 동안의 할인액을 반환해야 함</u><span style="color:red;">(② 해지 위약금)</span>.</p> 
		</td>
	</tr>
	<tr>
		<th>계약기간 자동연장<br/>(종량제형 限)</th>
		<td>
			<p>고객의 서비스 이용량에 따라 월 요금이 정해지는 종량제형의 경우, <u>계약기간 만료 시까지의 누적 요금이 약정한 매출보장액에 미달하면, 매출보장액 달성 시까지 계약이 1년씩 자동연장</u>되어야 함<span style="color:red;">(매출보장액 미달 시 자동연장)</span>.</p>
		</td>
	</tr>
	<tr>
		<th>서비스 장애 시<br/>손해배상책임 제한</th>
		<td>
			<p>서비스 장애로 인해 고객이 서비스를 원활하게 이용하지 못한 경우, 당사의 손해배상 금액은 <u>(i) 고객이 서비스를 이용하지 못한 기간에 해당하는 이용요금의 3배와 (ii) 월 이용요금 중 낮은 금액 이하로 제한되어야 함</u><span style="color:red;">(손해배상액 상한)</span>.</p>
		</td>
	</tr>
</table>
<h3 style="color:red">
	※장비투자형 서비스 제공계약의 법무 검토 요청 시 거래조건에 따른 유형을 선택하여야 법무검토가 가능합니다.<br/>
   	표준 조건과 비표준 조건 중 선택하신 후, 비표준 조건이나 기타를 선택하신 경우 이유를 자문사항에 별도 작성해주시기 바랍니다.
</h3>
<br/>
<br/>
<table class="basic">
	<tr>
		<th style="text-align:center;width:12%">항목</th>
		<th style="text-align:center;" colspan="3">거래조건</th>
		<th style="text-align:center;width:5%">선택</th>
	</tr>
	<tr>
		<th rowspan="6">중도해지</th>
		<th style="width:8%"  rowspan="3">표준조건</th>
		<td colspan="2" style="font-weight: bold;">
			<p>고객이 임의로 계약을 중도해지하거나 당사가 약정해지사유(고객 귀책사유)로 인하여 계약을 해지(이하 통칭하여 “<u>중도해지</u>”)할 경우, 당사는 고객에게 장비를 <u>취득가</u>로 매수할 것을 청구할 수 있으며<span style="color:red;">(① 장비매수청구권)</span>, 해지 위약금으로 <u>이용기간 동안의 할인액</u>*을 청구할 수 있음<span style="color:red;">(② 해지 위약금 청구권)</span>.</p> 
		</td>
		<td rowspan="3"  style="text-align: center;">
			<input type="radio" name="lms_pati_term_01" data-term="중도해지" value="표준조건">
		</td>
	</tr>
	<tr>
		<td style="width:8%">
			(① - 예시)
		</td>
		<td>
			 <p>“계약자”가 정당한 사정 없이 본 계약기간 만료 전에 본 계약을 해지하거나 “유플러스”가 본 계약상 해지사유로 인하여 본 계약을 해지할 경우, “유플러스”는 “계약자”에게 “장비”의 매수를 청구할 수 있으며, 이때 “계약자”는 “장비”의 매수를 청구 받은 날로부터 15일 이내에 ‘장비 상세내역서’에 명시된 ‘장비가액’을 “유플러스”에게 지급하고 “장비”를 매수하여야 한다.</p>
		</td>
	</tr>
	<tr>
		<td>
			(② - 예시)
		</td>
		<td>
			 <p>“계약자”가 정당한 사정 없이 본 계약기간 만료 전에 본 계약을 해지하거나 “유플러스”가 본 계약상 해지사유로 인하여 본 계약을 해지할 경우, “계약자”는 해지일로부터 30일 이내에 “유플러스”에게 다음의 위약금을 지급하여야 한다.* 해지 위약금 = 계약체결시점부터 해지 시까지 “계약자”가 약관상의 서비스 이용요금보다 할인 받은 금액의 총합</p>
		</td>
	</tr>
	<tr>
		<th rowspan="2">비표준조건</th>
		<th >유형1</th>
		<td>
			<ul>
				<li>[<u>① 장비매수청구권</u>]은 표준조건으로 적용하되, [<u>② 해지 위약금 청구권</u>]은 수정·삭제*하는 경우</li>
				<li>[<u>① 장비매수청구권</u>]의 장비매매가격을 잔존가로 감액**하거나, [<u>② 해지 위약금 청구권</u>]을 수정·삭제하는 경우</li> 
			</ul>
			<dl>
				<dd>*  <u>해지 위약금 청구권의 수정·삭제</u> : (i)  위약금 금액을 ‘할인액 전액’보다 낮은 금액으로 <u>하향 조정</u>하거나 (ii) 해지 위약금 청구권 조항을 <u>삭제</u></dd>
				<dd>** <u>장비매수가를 잔존가로 감액</u> : 장비 매매가격을 표준조건상의 ‘취득가액’에서 ‘잔존가액’으로 <u>하향 조정</u></dd> 
			</dl>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_01" data-term="중도해지" value="비표준유형1">
		</td>
	</tr>
	<tr>
		<th >유형2</th>
		<td>
			<dl>
				<dd>* <u>장비매수청구권을 삭제하면서 해지 위약금 청구권을 (i) 표준조건으로 적용하거나, (ii) 불리하게 수정하는 경우</u>들을 모두 하나의 비표준조건 유형으로 포괄함.</dd> 
			</dl>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_01" data-term="중도해지" value="비표준유형2">
		</td>
	</tr>
	<tr>
		<th>기타</th>
		<td colspan="2">
			<p>상기 비표준 조건에 해당하지 않으면서, 별도의 투자비 회수 담보규정이 없는 경우<br/>기타 조건은 상대방이 “정부, 지자체, 공공기관, 제1금융권 및 해외 대형사업자 등 협상력이 절대우위에 있는 고객”인 경우에만 선택가능하며, 그 외에는 표준 및 비표준 조건에서 선택 하여야 함</p>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_01" data-term="중도해지" value="기타">
		</td>
	</tr>
	<tr>
		<th rowspan="5">계약기간<br/>자동연장</th>
		<th style="width:8%"  rowspan="3">표준조건</th>
		<td colspan="2" >
			<p style="font-weight: bold;">
				고객의 서비스 이용량에 따라 월 요금이 정해지는 <u>종량제형 계약</u>의 경우, <u>계약기간 만료시까지의 누적 이용요금이 매출보장액*에 미달하면</u> 매출보장액을 달성할 때까지 계약이 1년씩 동일 조건으로 자동연장되어야 함<span style="color:red;">(매출보장액 미달 시 자동연장)</span>.
			</p>
			<dl>
				<dd>* 매출보장액은 당사가 해당 계약에서 손실을 보지 않기 위해 계약기간 동안 해당 고객사로부터 지급받아야 하는 이용요금의 총액으로서, 사업부에서 산정하고 투자심의위원회에서 검증함.</dd> 
			</dl>
		</td>
		<td rowspan="3"  style="text-align: center;">
			<input type="radio" name="lms_pati_term_02" data-term="자동연장" value="표준조건">
		</td>
	</tr>
	<tr>
		<td style="width:8%">
			(예시1)
		</td>
		<td>
			 <p>계약기간 만료시까지 총 서비스 이용요금이  금__원(부가세 별도)에 미달하는 경우 동일한 조건으로 1년씩 자동연장되는 것으로 한다.</p>
		</td>
	</tr>
	<tr>
		<td>
			(예시2)
		</td>
		<td>
			 <p>다음 각 호의 어느 하나에 해당하는 경우, 본 계약은 동일한 조건으로 1년씩 자동연장되는 것으로 한다.</p>
			 <ol>
			 	<li>계약기간 만료 시까지 총 서비스 이용요금이 금 __원(부가세 별도)에 미달하는 경우</li>
			 	<li>제1항의 계약기간 만료시까지 전국대표번호서비스 총 콜 수가 __콜에 미달하는 경우</li>
			 </ol>
		</td>
	</tr>
	<tr>
		<th style="width:8%">비표준조건</th>
		<td colspan="2" >
			<p style="font-weight: bold;">
				[<u>매출보장액 미달 시 자동연장</u>] 조항을 삭제하는 경우*
			</p>
			<ol type="i">
				<li>매출보장액에 달할 때까지 자동연장되는 것이 아니라, <u>1회에 한하여 1개월~6개월 정도만 연장하는 것으로 수정하는 경우</u></li>
				<li><u>매출보장액을 현저히 낮은 금액으로 수정</u>하여 계약기간 만료 시점의 누적 이용요금이 매출보장액에 미달될 가능성이 사실상 없게 되는 경우(예컨대 적정 매출보장액은 1억 원인데 이를 5천만 원으로 낮출 경우)</li>
				<li>기타 위와 유사하게 <u>자동연장 조항을 사실상 형해화시키는 정도로 수정</u>하는 경우</li>
			</ol>
		</td>
		<td  style="text-align: center;">
			<br/>
			<br/>
			<input type="radio" name="lms_pati_term_02" data-term="자동연장" value="비표준1"><br/>
			<input type="radio" name="lms_pati_term_02" data-term="자동연장" value="비표준2"><br/>
			<br/>
			<input type="radio" name="lms_pati_term_02" data-term="자동연장" value="비표준3"><br/>
		</td>
	</tr>
	<tr>
		<th style="width:8%">기타</th>
		<td colspan="2" >
			<p style="font-weight: bold;">
				상기 비표준 조건에 해당하지 않으면서, 별도의 투자비 회수 담보규정이 없는 경우<br/>
				기타 조건은 상대방이 “정부, 지자체, 공공기관, 제1금융권 및 해외 대형사업자 등 협상력이 절대우위에 있는 고객”인 경우에만 선택가능하며, 그 외에는 표준 및 비표준 조건에서 선택 하여야 함
			</p>
		</td>
		<td  style="text-align: center;">
			<input type="radio" name="lms_pati_term_02" data-term="자동연장" value="기타"><br/>
		</td>
	</tr>
	<tr>
		<th rowspan="5">서비스 장애시<br/>손배배상책임 제한</th>
		<th style="width:8%"  rowspan="2">표준조건</th>
		<td colspan="2" >
			<p style="font-weight: bold;">
				서비스 장애로 인해 고객이 서비스를 원활하게 이용하지 못한 경우 당사의 손해배상 금액은 <u>(i) 서비스를 이용하지 못한 기간에 해당하는 이용요금* 3배와 (ii) 월 서비스 이용요금 중 낮은 금액 이하</u>로 제한되어야 함<span style="color:red;">(손해배상액 상한)</span>.
			</p>
			<dl>
				<dd>* 이용요금: 정액제형 계약의 경우 월정 이용요금, 종량제형 계약의 경우 지난 3개월 간 이용요금의 평균.</dd> 
			</dl>
		</td>
		<td rowspan="2"  style="text-align: center;">
			<input type="radio" name="lms_pati_term_03" data-term="손해배상" value="표준조건">
		</td>
	</tr>
	<tr>
		<td>(예시)</td>
		<td>
			<p>
				[<span style="color:red;">정액제형 계약의 경우</span>] 제8조 (서비스의 장애 등 손해배상) ① 서비스 제공기간 중 “유플러스”의 설비장애로 인하여 “계약자”가 서비스를 원활하게 이용하지 못하여 “계약자”가 서비스를 사용할 수 없다는 뜻을 “유플러스”에게 통지 또는 그 이전에 “유플러스”가 그 사실을 스스로 인지한 때로부터 계속 [3]시간 이상 사용하지 못한 때에는 사용하지 못한 기간에 해당하는 요금의 3배 금액을 기준으로 상호 협의하여 손해를 배상한다. 단, 손해배상 금액은 1개월 서비스 이용요금을 초과하지 아니한다.
			</p>
			<dl>
				<dd>* 매출보장액은 당사가 해당 계약에서 손실을 보지 않기 위해 계약기간 동안 해당 고객사로부터 지급받아야 하는 이용요금의 총액으로서, 사업부에서 산정하고 투자심의위원회에서 검증함.</dd> 
			</dl>
		</td>
	</tr>
	<tr>
		<th rowspan="2">비표준조건</th>
		<th >유형1</th>
		<td>
			<p>[손해배상액 상한]을 상향 조정*하는 경우 (예: 월 이용요금의 10배) </p>
			<dl>
				<dd>* 상한은 누적 이용요금(장애 발생일 이전까지 당사가 고객으로부터 지급받은 이용요금 총액) 이하여야 함</dd>
			</dl>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_03" data-term="손해배상" value="비표준유형1">
		</td>
	</tr>
	<tr>
		<th >유형2</th>
		<td>
			<p>[손해배상액 상한]을 삭제하는 경우* </p>
			<dl>
				<dd>* <u>누적 이용요금을 초과하는 수준의 금액으로 손해배상액 상한을 상향 조정하는 경우</u> (예: ‘약정한 계약기간 동안의 예상 총 매출액’으로 상한을 정하는 경우), 당사가 장애 발생일 이전까지 해당 계약에서 창출한 매출을 초과하여 손해배상액을 지급하게 되는 경우가 있을 수 있으므로, 이러한 상향 조정은 손해배상액 상한을 삭제하는 것과 동일하게 취급함.</dd> 
			</dl>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_03" data-term="손해배상" value="비표준유형2">
		</td>
	</tr>
	<tr>
		<th>기타</th>
		<td colspan="2">
			<p>상기 비표준 조건에 해당하지 않으면서, 별도의 투자비 회수 담보규정이 없는 경우 <br/>기타 조건은 상대방이 “정부, 지자체, 공공기관, 제1금융권 및 해외 대형사업자 등 협상력이 절대우위에 있는 고객”인 경우에만 선택가능하며, 그 외에는 표준 및 비표준 조건에서 선택 하여야 함</p>
		</td>
		<td style="text-align: center;">
			<input type="radio" name="lms_pati_term_03" data-term="손해배상" value="기타">
		</td>
	</tr>
</table>