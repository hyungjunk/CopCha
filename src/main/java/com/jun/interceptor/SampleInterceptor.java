package com.jun.interceptor;

import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SampleInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(
			HttpServletRequest request
			, HttpServletResponse response
			, Object handler) throws Exception { //Handler�� ���� �����Ϸ��� �޼ҵ� ��ü. ��, preHandle�� ���
		System.out.println("pre handle....");

		HandlerMethod method = (HandlerMethod) handler; // handler(�����ϴ� �޼ҵ�)�� HandlerMethod�� ĳ����
		Method methodObj = method.getMethod();
		
		System.out.println("Bean: " + method.getBean());	// ���� ����Ǵ� Bean ����
		System.out.println("Method "+ methodObj);			// ���� ����Ǵ� Method ����
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request
			, HttpServletResponse response
			, Object handler
			, ModelAndView modelAndView) throws Exception {
		System.out.println("post handle...");
		
		Object result = modelAndView.getModel().get("result");
		System.out.println("Interceptor result "+result);
		if(result!=null) {
			request.getSession().setAttribute("result", result);
			response.sendRedirect("/doB");
		}
	}
	
}
