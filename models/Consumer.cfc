/**
 * This class will implement com.rabbitmq.client.Consumer
 * https://rabbitmq.github.io/rabbitmq-java-client/api/current/com/rabbitmq/client/Consumer.html
 * Interface for application callback objects to receive notifications and messages from a queue by subscription.
 */
component accessors="true"{


    /**
     * Constructor
     *
     * @channel RabbitMQ Connection Channel https://rabbitmq.github.io/rabbitmq-java-client/api/current/com/rabbitmq/client/Channel.html
     * @consumerTag The consumer tag associated with the consumer
     */
    function init( required channel, consumerTag = "" ){
        variables.channel       = arguments.channel;
		variables.consumerTag   = arguments.consumerTag;

		variables.appScope 		= application;

        return this;
	}

	public function getChannel(){
		return variables.channel;
	}

    /**
     * No-op implementation of {@link Consumer#handleCancel}.
     * @param consumerTag the defined consumer tag (client- or server-generated)
     */
    public void function handleCancel( String consumerTag ){
        // no work to do
    }

    /**
     * No-op implementation of {@link Consumer#handleCancelOk}.
     * @param consumerTag the defined consumer tag (client- or server-generated)
     */
    public void function handleCancelOk( String consumerTag ){
		// Close the channel
		variables.channel.close();
    }

     /**
     * Stores the most recently passed-in consumerTag - semantically, there should be only one.
     * @see Consumer#handleConsumeOk
     */
    public void function handleConsumeOk( String consumerTag ){
        variables.consumerTag = arguments.consumerTag;
    }

     /**
     * No-op implementation of {@link Consumer#handleDelivery}.
     */
    public void function handleDelivery(
        consumerTag,
        envelope,
        properties,
        body
    ){
        try {
            local.Message = ToString(arguments.body, "utf-8");
            ArrayAppend(variables.appScope.logs, local.Message);
            include "query.cfm";
            ArrayAppend(variables.appScope.logs, test.Record);
            channel.basicAck( envelope.getDeliveryTag(), false );
        } catch (Any e) {
            ArrayAppend(variables.appScope.logs, e);
        }
    }

    /**
     * No-op implementation of {@link Consumer#handleRecoverOk}.
     */
    public void function handleRecoverOk(){
        // no work to do
    }

    /**
     * No-op implementation of {@link Consumer#handleShutdownSignal}.
     */
    public void function handleShutdownSignal( String consumerTag, sig ){
        // no work to do
    }

}