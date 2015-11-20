<error>
	<span class="error-msg">{ opts.err }</span>
	
	<style scoped>
		:scope {
			position: static;
			display: block;
			float: right;
			color: white;
			background-color: #c83f3f;
			font-weight: bold;
			font-size: 0.8em;
			line-height: 20px;
			padding: 0 5px;
		}
		
		
	</style>
	<script>
		this.on('mount', function() {
			console.log("mounting errro");
		});
	</script>
</error>