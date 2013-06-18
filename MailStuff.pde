// Dave Robertson - 2013 dhrobertson.com
//
// Simple E-mail Checking - tweaked from // Daniel Shiffman http://www.shiffman.net
//
// This code requires the Java mail library - current version 1.4.7
// All jars in the code folder 
// Download: http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-eeplat-419426.html#javamail-1.4.7-oth-JPR
// Best to google it
import javax.activation.*;
import javax.mail.Multipart;
import java.util.Properties;
import java.io.*;
import java.util.*;
import javax.mail.*;
import javax.mail.Flags.Flag;
import javax.mail.internet.*;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

// Function to send email - IMAP

void sendMail(String email) 
{
  try {

    Properties props = new Properties();

    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.socketFactory.port", "465");
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.port", "465");

    // Create authentication object
    Auth auth = new Auth();

    Session session = Session.getDefaultInstance(props, auth);

    try {

      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress("switchflip.shaun@gmail.com"));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
      message.setSubject("Audio Recording");
      
      
      BodyPart messageBodyPart = new MimeBodyPart();
      // Fill the message
      messageBodyPart.setText("Audio Recording using Processing and javaMail");
      Multipart multipart = new MimeMultipart();
      multipart.addBodyPart(messageBodyPart);
      // Part two is attachment
      messageBodyPart = new MimeBodyPart();
      DataSource source = new FileDataSource(dataPath("myrecording.wav"));
      messageBodyPart.setDataHandler(new DataHandler(source));
      messageBodyPart.setFileName(String.valueOf(day())+String.valueOf(month())+String.valueOf(year())+".wav");
      multipart.addBodyPart(messageBodyPart);
      message.setContent(multipart);
      message.setSentDate(new Date());
      
      Transport.send(message);

      System.out.println("Done");
    } 

    finally 
    {
      //session.close();
    }
  }
  catch (MessagingException e) 
  {
      throw new RuntimeException(e);
  }
}

