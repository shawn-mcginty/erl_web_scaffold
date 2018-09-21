<template>
	<div class="container is-fluid">
		<div class="columns is-mobile">
			<div class="column"></div>
			<div class="column is-four-fifths-mobile is-three-fifths-tablet is-half-desktop">
				<p class="title is-3">Login</p>
				<p class="subtitle is-5">If you dare.</p>
			</div>
			<div class="column"></div>
		</div>
		<div class="columns is-mobile">
			<div class="column"></div>
			<div class="column is-four-fifths-mobile is-half-tablet is-two-fifths-desktop">
				<form method="POST" action="/login">
					<div class="field">
						<p class="control has-icons-left has-icons-right">
							<input class="input" type="email" placeholder="Email" autocomplete="username" name="email">
							<span class="icon is-small is-left">
								<i class="fas fa-envelope"></i>
							</span>
						</p>
					</div>
					<div class="field">
						<p class="control has-icons-left">
							<input class="input" type="password" placeholder="Password" autocomplete="current-password" name="pword">
							<span class="icon is-small is-left">
								<i class="fas fa-lock"></i>
							</span>
						</p>
					</div>
					<div class="field">
						<p class="control">
							<button class="button is-primary" type="submit">
								Login
							</button>
						</p>
					</div>
				</form>
			</div>
			<div class="column"></div>
		</div>
		<div v-if="failed" class="columns is-mobile">
			<div class="column"></div>
			<div class="column is-four-fifths-mobile is-half-tablet is-two-fifths-desktop">
				<div class="card animated bounceIn">
					<header class="card-header">
						<p class="card-header-title">Login Failed</p>
					</header>
					<div class="card-content">
						<div class="content">
							This combination of email and password was not found.  Please try again.
						</div>
					</div>
				</div>
			</div>
			<div class="column"></div>
		</div>
	</div>
</template>
<script>
	const urlQueryParams = new URLSearchParams(window.location.search);
	const failed = JSON.parse(urlQueryParams.get('failed') === null ? false : urlQueryParams.get('failed'));

	const LoginForm = {
		data () {
			return {
				failed,
			};
		},
	};

	module.exports = LoginForm;
</script>