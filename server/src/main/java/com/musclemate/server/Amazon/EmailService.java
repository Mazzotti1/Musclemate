package com.musclemate.server.Amazon;

import io.github.cdimascio.dotenv.Dotenv;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;



public class EmailService {

    public static void sendSimpleMessage(String email, String recoveryCode) {

        Dotenv dotenv = Dotenv.load();

        String apiKey = dotenv.get("API_KEY");

        HttpClient client = HttpClientBuilder.create().build();
        HttpPost post = new HttpPost(dotenv.get("DOMAIN"));


        post.setHeader("Authorization", "Basic " + Base64.getEncoder().encodeToString(("api:" + apiKey).getBytes()));


        List<NameValuePair> parameters = new ArrayList<>();
        parameters.add(new BasicNameValuePair("from", "Mailgun Sandbox <postmaster@YOUR_MAILGUN_DOMAIN>"));
        parameters.add(new BasicNameValuePair("to", email));
        parameters.add(new BasicNameValuePair("subject", "Codigo Musclemate"));
        parameters.add(new BasicNameValuePair("text", "Seu codigo de recuperacao de senha e: " + recoveryCode));

        try {
            post.setEntity(new UrlEncodedFormEntity(parameters));

            // Enviar a solicitação
            HttpResponse response = client.execute(post);
            HttpEntity entity = response.getEntity();
            String responseString = EntityUtils.toString(entity);

            // Verificar a resposta
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode == 200) {
                System.out.println("Email enviado com sucesso!");
            } else {
                System.out.println("Falha ao enviar o email. Código de status: " + statusCode);
                System.out.println("Resposta: " + responseString);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }



}






