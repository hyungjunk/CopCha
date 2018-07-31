package com.jun.controller;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jun.domain.Criteria;
import com.jun.domain.MovBoardVO;
import com.jun.domain.PageMaker;
import com.jun.domain.SearchCriteria;
import com.jun.service.CommentServiceImpl;
import com.jun.service.MovBoardServiceImpl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/mov/*")
public class MovBoardController {
	
	@Autowired(required=false)
	private MovBoardServiceImpl service;
	
	@Inject
	private CommentServiceImpl cservice;
	
	private static final Logger logger = LoggerFactory.getLogger(MovBoardController.class);

	@RequestMapping(value = "board", method = RequestMethod.GET)
	public String showMovieBoard(
			Model model
			, Criteria cri) throws Exception {
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		logger.info(cri.toString());
		pageMaker.setTotalCount(service.countPost());   // Comment section�� ������
//		pageMaker.setTotalCount(cservice.countComments()); // �� �� �̰ɷ� �ٲ���� (������ ���񺸵� ����)
		model.addAttribute("rank", service.rankList());  // ��ŷ ����
		model.addAttribute("top", service.readTop()); // top ��������
		model.addAttribute("mid", service.readMid()); // mid ��������
//		model.addAttribute("pageMaker", pageMaker); // �Խ��� �� ����¡ ��ü
		return "/mov/board";
	}
	
	@RequestMapping(value = "board/detail", method = RequestMethod.GET)
	public @ResponseBody MovBoardVO showMovieDetail(@ModelAttribute("info") MovBoardVO vo, Model model) throws Exception {
		vo = (MovBoardVO)service.read(1);
		System.out.println(vo);
		return vo; 
	}
	
	@RequestMapping(value = "search", method = RequestMethod.GET)
	public String showGenreList(
			@RequestParam("genre") String genre
			, SearchCriteria cri
			, Model model
			) throws Exception {
		cri.setGenre(genre);
		logger.info(cri.toString());
		model.addAttribute("genre", genre); // ���� �˻�����¡�� ���� 
		model.addAttribute("list", service.genreList(cri));
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		pageMaker.setTotalCount(service.totalCountPerGenre(cri));
		model.addAttribute("pageMaker", pageMaker);
		return "/mov/search"; 
	}
	
}
