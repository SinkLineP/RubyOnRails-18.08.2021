from flask import Flask, render_template
app = Flask(__name__)

posts = [
	{
		'author': 'Artem Popov',
		'title': 'Blog post 1',
		'content': 'It my firs stats',
		'date_posted': '20.September.2019',
	},
	{
		'author': 'Karina Popova',
		'title': 'Blog post 2',
		'content': 'It`s my two stats',
		'date_posted': '20.September.2019',
	}
]

@app.route('/')
@app.route('/home')
def hello():
    return render_template('home.html', posts=posts)

@app.route('/about')
def about():
    return render_template('about.html')


if __name__ == '__main__':
    app.run(debug=True)