package com.springboot.springjdbc.config;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.springboot.springjdbc.model.MemberDao;
import com.springboot.springjdbc.model.MemberDo;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private MemberDao memberDao;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            // ★★★ 모든 요청(/**)을 다 허용(permitAll) ★★★
            // 로그인 체크는 이제 BoardControllerSpring에서 직접 함
            .requestMatchers(new AntPathRequestMatcher("/**")).permitAll()
            )
            .oauth2Login(oauth2 -> oauth2
                .loginPage("/login.do") // 로그인 페이지 URL
                .successHandler(new AuthenticationSuccessHandler() {
                    @Override
                    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                            Authentication authentication) throws IOException, ServletException {
                        
                        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) authentication;
                        String registrationId = token.getAuthorizedClientRegistrationId();
                        OAuth2User oAuth2User = token.getPrincipal();

                        String email = null;
                        String name = null;
                        String providerId = null;

                        if ("naver".equals(registrationId)) {
                            Map<String, Object> responseMap = (Map<String, Object>) oAuth2User.getAttribute("response");
                            email = (String) responseMap.get("email");
                            name = (String) responseMap.get("name");
                            providerId = (String) responseMap.get("id");
                        } 
                        else if ("kakao".equals(registrationId)) {
                            Map<String, Object> properties = (Map<String, Object>) oAuth2User.getAttribute("properties");
                            name = (String) properties.get("nickname");
                            providerId = String.valueOf(oAuth2User.getAttribute("id"));
                            email = "kakao_" + providerId + "@kakao.com";
                        }

                        // DB 처리
                        MemberDo member = memberDao.findByEmail(email);
                        if (member == null) {
                            memberDao.insertMember(email, name, registrationId, providerId);
                            member = memberDao.findByEmail(email); 
                        }

                        HttpSession session = request.getSession();
                        session.setAttribute("member", member); 
                        response.sendRedirect("/getBoardList.do");
                    }
                })
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/getBoardList.do")
                .invalidateHttpSession(true)
            );

        return http.build();
    }
}