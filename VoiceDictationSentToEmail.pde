//GUI include
import g4p_controls.*;
//emailer include
import javax.mail.*;
import javax.mail.internet.*;
//audio control include
import ddf.minim.*;                //import minim to handle sound recordings

Minim minim;                       //create minim object
AudioInput in;                     //create line in object to connect to mic
AudioRecorder recorder;            //create record object to record input stream

GTextField txf1;                   //create text field1
GTabManager tt;                    //create tab manager.
GImageButton btnMic, btnEmail;     //create 2 buttons

//Global variables
String email = "shaun.robert.mulligan@gmail.com";      //default receipent email address
float sampleRate = 32000;

void setup() {
  size(512,200,P2D);
  cursor(CROSS);
  String[] files;

  //define GUI components
  files = new String[] { 
    "mic_w_128.png", "mic_w_128.png", "mic_b_128.png"
  };
  btnMic = new GImageButton(this, 0, 136, files);
  
  files = new String[] { 
    "email.png", "email.png", "email_arrow.png"
  };
  btnEmail = new GImageButton(this, 440, 136, files);
  
  txf1 = new GTextField(this, 10, 10, 200, 20);
  txf1.tag = "txf1";
  txf1.setDefaultText("email@address.com");
  
  tt = new GTabManager();
  tt.addControls(txf1);
  
  minim = new Minim(this);         //construct new minim instance
  
  in = minim.getLineIn(Minim.MONO, 512,sampleRate);      //connect audioInput object to lineIn object stream
  //need to change foward slash to backslash for
  recorder = minim.createRecorder(in,dataPath("myrecording.wav"),true);  //point recorder at file to save to.
  textFont(createFont("SanSerif",14));            //set up font style in window.
  
}

void draw()
{
  background(40, 40, 40); 
  stroke(255);
  text("Confirm email with Enter!", 220, 25);
  // draw the waveforms
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(i, 100 + in.left.get(i)*50, i+1, 100 + in.left.get(i+1)*50);
  }
  
  if ( recorder.isRecording() )
  {
    text("Currently recording...", 64, 170);
  }
  else
  {
    text("Not recording.", 64, 170);
  }
}

void keyReleased()
{
  if ( key == ' ' ) 
  {
    // to indicate that you want to start or stop capturing audio data, you must call
    // beginRecord() and endRecord() on the AudioRecorder object. You can start and stop
    // as many times as you like, the audio data will be appended to the end of the buffer 
    // (in the case of buffered recording) or to the end of the file (in the case of streamed recording). 
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    else 
    {
      recorder.beginRecord();
    }
  }
  if (key == CODED &&  keyCode == ALT )
  {
    // we've filled the file out buffer, 
    // now write it to the file we specified in createRecorder
    // in the case of buffered recording, if the buffer is large, 
    // this will appear to freeze the sketch for sometime
    // in the case of streamed recording, 
    // it will not freeze as the data is already in the file and all that is being done
    // is closing the file.
    // the method returns the recorded audio as an AudioRecording, 
    // see the example  AudioRecorder >> RecordAndPlayback for more about that
    recorder.save();
    // Function to send mail
    sendMail(email);
    println("Done saving.");
  }
}

public void handleTextEvents(GEditableTextControl tc, GEvent event) { 
  System.out.print("\n" + tc.tag + "   Event type: ");
  switch(event) {
  case CHANGED:
    System.out.println("CHANGED");
    break;
  case SELECTION_CHANGED:
    System.out.println("SELECTION_CHANGED");
    System.out.println(tc.getSelectedText() + "\n");
    break;
  case ENTERED:
    System.out.println("ENTER KEY TYPED");
    email = tc.getText();
    System.out.println(tc.getText() + "\n");
    break;
  default:
    System.out.println("UNKNOWN");
  }
}

void handleButtonEvents(GImageButton button, GEvent event) {
  if (button == btnMic){
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    else 
    {
      recorder.beginRecord();
    }
    println("record pressed");
  }
  else if (button == btnEmail){
    recorder.save();
    // Function to send mail
    sendMail(email);
    println("email pressed");
  }
  else
  ;
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  
  super.stop();
}
