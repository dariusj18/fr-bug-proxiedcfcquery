<cfif StructKeyExists(url, "reinit")>
	<cfset structDelete(application, "Consumer") />
</cfif>
<cfif NOT StructKeyExists(application, "Consumer")>
	<cfscript>
	channel = application.connection.createChannel();

	channel.exchangeDeclare("test.exchange", "topic");
	queueName = channel.queueDeclare().getQueue();

	channel.queueBind(queueName, "test.exchange", "##");

	// Prepare a push consumer
	application.Consumer = createDynamicProxy(
		new models.Consumer( channel ),
		[ "com.rabbitmq.client.Consumer" ]
	);
	// Consume Stream API
	consumerTag = channel.basicConsume(queueName, application.Consumer );
	</cfscript>

	<cfoutput>
	<h1>Consumer started with consumer tag: #consumerTag#!</h1>
	</cfoutput>
<cfelse>
	<h1>Consumer is consuming</h1>
	<cfdump var="#application.Consumer#" />
</cfif>