<cfparam name="url.Message" default="#createUUID()#" />

<cfscript>
application.channel.basicPublish( 
	"test.exchange",
	"", // routing key
	javaCast( "null", "" ), // properties
	url.Message.getBytes() // message body the price in bytes
);
</cfscript>