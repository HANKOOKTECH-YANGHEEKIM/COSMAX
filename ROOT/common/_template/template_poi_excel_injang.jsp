<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.apache.poi.*"%>
<%@ page import="org.apache.poi.hssf.usermodel.*"%>
<%@ page import="org.apache.poi.hssf.util.*"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	String CONTENT_NAME = (String)request.getAttribute(CommonConstants.CONTENT_NAME);
	String action_code 	= request.getParameter(CommonConstants.ACTION_CODE);
	String mode_code 	= request.getParameter(CommonConstants.MODE_CODE);
	
	String data  	= resultMap.getString("DATA");
	
	String json_params = StringUtil.convertNull(data);
	Map<String, Object> map = JsonUtil.parseJsonStringToMap(json_params);
	ArrayList header = (ArrayList)map.get("header");
	ArrayList rows = (ArrayList)map.get("rows");
	
	int total    = (Integer)map.get("total");
	String title = (String)map.get("title");
	String file_save_name = "";
	
	if("".equals(title)){
		title = CONTENT_NAME;
	}
	
	file_save_name = FileUtil.escapeFilename(title) + ".xls";		
	file_save_name = FileUtil.getAttachmentFilename(request, file_save_name, "UTF-8");	
		
	response.reset();		
	response.setHeader("Content-Disposition", "attachment; filename="+ file_save_name);
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Pragma", "no-cache;");
	response.setHeader("Expires", "-1;");
	
	HSSFWorkbook workbook = new HSSFWorkbook();
		
	HSSFSheet sheet = workbook.createSheet("Sheet1");
	sheet.setDefaultColumnWidth(20);
	sheet.addMergedRegion(new Region(0,(short)0,0,(short)(header.size() - 1)));
	sheet.addMergedRegion(new Region(1,(short)0,1,(short)(header.size())));	
	
	//Font 설정.
	HSSFFont font = workbook.createFont();
	font.setFontName("맑은 고딕");
	
	HSSFFont font_Header = workbook.createFont();
	font_Header.setFontName("맑은 고딕");
	font_Header.setFontHeightInPoints((short)24);
	font_Header.setBoldweight((short)2);
	
	HSSFFont font_Sub_Header = workbook.createFont();
	font_Header.setFontName("맑은 고딕");
	
	//제목의 스타일 지정
	HSSFCellStyle titlestyle = workbook.createCellStyle();
	titlestyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
	titlestyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
	titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	titlestyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	titlestyle.setBottomBorderColor(HSSFColor.BLACK.index);
	titlestyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
	titlestyle.setLeftBorderColor(HSSFColor.BLACK.index);
	titlestyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
	titlestyle.setRightBorderColor(HSSFColor.BLACK.index);
	titlestyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
	titlestyle.setTopBorderColor(HSSFColor.BLACK.index);
	titlestyle.setFont(font);
	
	HSSFCellStyle HeaderStyle = workbook.createCellStyle();
	HeaderStyle.setFont(font_Header);
	HeaderStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	HeaderStyle.setVerticalAlignment (HSSFCellStyle.VERTICAL_CENTER);

	

	
	HSSFCellStyle SubHeaderStyle = workbook.createCellStyle();
	SubHeaderStyle.setFont(font_Sub_Header);
	
	HSSFRow row = sheet.createRow((short)0);
	row.setHeight((short)1000);
	HSSFCell cellHeader1 = row.createCell((short)0 );
	cellHeader1.setCellValue(title);
	cellHeader1.setCellStyle(HeaderStyle);
	
	row = sheet.createRow((short)1);
	HSSFCell cellHeader2 = row.createCell((short)0 );
	cellHeader2.setCellValue("총 : " + total+"건");
	cellHeader2.setCellStyle(SubHeaderStyle);
	
	HSSFCellStyle cellStyle = workbook.createCellStyle();
	
	if(header != null && header.size() > 0){
		row = sheet.createRow((short)2);
		for(int i=0; i<header.size(); i++){
			//System.out.println((String)((Map<String, Object>)header.get(i)).get("FIELD_ID"));
			HSSFCell cell = row.createCell((short)i);
			cell.setCellValue((String)((Map<String, Object>)header.get(i)).get("FIELD_NAME"));			
			
			if("LEFT".equals((String)((Map<String, Object>)header.get(i)).get("HALIGN"))){
				cellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			}else if("CENTER".equals((String)((Map<String, Object>)header.get(i)).get("HALIGN"))){
				cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			}else if("RIGHT".equals((String)((Map<String, Object>)header.get(i)).get("HALIGN"))){
				cellStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
			}
			cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
			cellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
			cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
			cellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
			cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
			cellStyle.setRightBorderColor(HSSFColor.BLACK.index);
			cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
			cellStyle.setTopBorderColor(HSSFColor.BLACK.index);
			cellStyle.setFont(font);
			cell.setCellStyle(cellStyle);
			sheet.setColumnWidth((int)i, Integer.parseInt((String)((Map<String, Object>)header.get(i)).get("WIDTH"))*50);
		}
	}
	
	
	//Row 생성
	HSSFCellStyle dataCellStyle = workbook.createCellStyle();
	
	if(rows != null && rows.size() > 0){
		
		String tmp_hoesa_nam	= "";
		int hoesa_num = 1;
		int merge_row_start = 3;
		int merge_row_end = 0;
		
		for(int i=0; i<rows.size(); i++){
			row = sheet.createRow((short)(i+3));
			if(header != null && header.size() > 0){
				for(int j=0; j<header.size(); j++){					
					
					dataCellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
					dataCellStyle.setBottomBorderColor(HSSFColor.BLACK.index);
					dataCellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
					dataCellStyle.setLeftBorderColor(HSSFColor.BLACK.index);
					dataCellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
					dataCellStyle.setRightBorderColor(HSSFColor.BLACK.index);
					dataCellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
					dataCellStyle.setTopBorderColor(HSSFColor.BLACK.index);
					
					
					HSSFCell cell = row.createCell((short)j);
					String field_id = (String)((Map<String, Object>)header.get(j)).get("FIELD_ID");
					String field_val = (String)((Map<String, Object>)rows.get(i)).get(field_id);
					
					if("HOESA_NAM".equals(field_id) && "".equals(field_val)){
						field_val = "총합계";
					}
					
					if(!"총합계".equals(tmp_hoesa_nam) && "INJANG_TYPE_NAM".equals(field_id) && "".equals(field_val)){
						field_val = "합계";
					}
					
					cell.setCellValue(field_val);
					
					if("HOESA_NAM".equals(field_id)){
						if(i != 0 && !tmp_hoesa_nam.equals(field_val)){
							merge_row_end = i + 2;
						}
						tmp_hoesa_nam = field_val;
					}
					
				
					if("LEFT".equals((String)((Map<String, Object>)header.get(j)).get("ALIGN"))){						
						dataCellStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
					}else if("CENTER".equals((String)((Map<String, Object>)header.get(j)).get("ALIGN"))){
						dataCellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
					}else if("RIGHT".equals((String)((Map<String, Object>)header.get(j)).get("ALIGN"))){
						dataCellStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
					}
					cell.setCellStyle(dataCellStyle);
				} // for
			}
			System.out.println("#merge_row_start = " + Integer.toString(merge_row_start));
			System.out.println("#merge_row_end = " + Integer.toString(merge_row_end));
			System.out.println("#hoesa_num = " + Integer.toString(hoesa_num));
			if(merge_row_end > 0){
				sheet.addMergedRegion(new Region(merge_row_start, (short)0, merge_row_end, (short)0));	// NO 셀 합치기
				sheet.addMergedRegion(new Region(merge_row_start, (short)1, merge_row_end, (short)1));	// 회사 셀 합치기
				
				HSSFCell noCell;
				HSSFCell hoesaCell;
				noCell = sheet.getRow(merge_row_start).getCell(0);
				noCell.setCellValue(hoesa_num);
				hoesaCell = sheet.getRow(merge_row_start).getCell(1);
				
				HSSFCellStyle addStyle = workbook.createCellStyle();
				addStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				addStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				addStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				addStyle.setBottomBorderColor(HSSFColor.BLACK.index);
				addStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				addStyle.setLeftBorderColor(HSSFColor.BLACK.index);
				addStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
				addStyle.setRightBorderColor(HSSFColor.BLACK.index);
				addStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
				addStyle.setTopBorderColor(HSSFColor.BLACK.index);				
				
				noCell.setCellStyle(addStyle);
				hoesaCell.setCellStyle(addStyle);

				
				merge_row_start = merge_row_end + 1;
				merge_row_end = 0;
				hoesa_num += 1;
			}
			
		} // for
	}

	 out.clear();
     out = pageContext.pushBody();
     OutputStream xlsOut = response.getOutputStream(); //OutputStream으로 엑셀을 저장한다.
     
     workbook.write(xlsOut);
%>