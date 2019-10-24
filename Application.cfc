component{

	this.name = "RabbitMQ Consumer";
	this.javaSettings = { loadPaths = [ "/lib" ] };

	function onApplicationStart(){

		if (StructKeyExists(application, "connection")) {
			application.connection.close();
		}

		// create connection factory
		application.factory = createObject( "java", "com.rabbitmq.client.ConnectionFactory" ).init();
		application.factory.setAutomaticRecoveryEnabled( true );
		// application.factory.setUsername( "rabbitmq" );
		// application.factory.setPassword( "rabbitmq" );
		// Create a shared connection for this application
		application.connection = application.factory.newConnection();
		application.channel = application.connection.createChannel();
		application.channel.exchangeDeclare("test.exchange", "topic");
		application.Logs = [];
		writeDump("onApplicationStart");
		writeDump(application);
		return true;
	}

	function onApplicationEnd(){
		// close connection
		writedump("onApplicationEnd");
		application.connection.close();
		abort;
	}

	function onRequestStart( required targetPage ){
		if( structKeyExists( url, "reinit" ) ){
			onApplicationStart();
		}
		return true;
	}

}