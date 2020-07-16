// Twitter - Proccessing - Max
// Consumer and access keys have been removed for privacy
// Developed from Programing For People video tutorial

import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress myRemoteLocation;

ConfigurationBuilder cb = new ConfigurationBuilder();
Twitter twitterInstance;
Query queryForTwitter;

String hashTag = "#tinder";

ArrayList tweets;

void setup() {
  cb.setOAuthConsumerKey("HERE");
  cb.setOAuthConsumerSecret("HERE");
  cb.setOAuthAccessToken("HERE");
  cb.setOAuthAccessTokenSecret("HERE");

  twitterInstance = new TwitterFactory(cb.build()).getInstance();

  //looking for osc data IN to processing
  osc = new OscP5(this, 12000);

  //sending data from processing to max
  myRemoteLocation = new NetAddress("127.0.0.1", 13000);

  FetchTweets();
}//end setup

void draw() {
}

void FetchTweets() {
  queryForTwitter = new Query(hashTag);

  try {
    QueryResult results = twitterInstance.search(queryForTwitter);
    tweets = (ArrayList) results.getTweets();
  }

  catch (TwitterException te) {
    println("Couldn't connect " + te);
  } //end catch

  //drawTweets();
  sendTweets();
} //end fetchtweets

void drawTweets() {
  for (int i=0; i<tweets.size(); i++) {
    Status t = (Status) tweets.get(i);
    String user = t.getUser().getName();
    String msg = t.getText();
    print(msg + ": " + user);
  }
}//end drawtweets

void oscEvent(OscMessage theOscMessage) {    //print the osc data recieved
  print("recieved an OSC message");
  println("value: " + theOscMessage.get(0).stringValue());
  hashTag = theOscMessage.get(0).stringValue();
  //println(hashTag);

  FetchTweets();
} //end oscevent

// having trouble sending tweets without max crashing, unsure of solution
void sendTweets() {
  for (int i=0; i<tweets.size(); i++) {
    Status t = (Status) tweets.get(i);
    String user = t.getUser().getName();
    String msg = t.getText();

    OscMessage myMessage = new OscMessage("/tweets");
    myMessage.add("set 0 " + i + " " + user + ": " + msg); // adding "set 0" + i made max crash
    osc.send(myMessage, myRemoteLocation);
  }
} //end sendtweets
