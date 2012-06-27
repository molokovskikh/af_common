// List following and followers from several accounts

var users = ['sencha',
        'aconran',
        'ariyahidayat',
        'darrellmeyer',
        'DavidKaneda',
        'DmitryBaranovsk',
        'donovanerba',
        'edspencer',
        'helder_correia',
        'jamespearce',
        'jamieavins',
        'jarrednicholls',
        'jayrobinson',
        'lojjic',
        'mmullany',
        'philogb',
        'rdougan',
        'tmaintz',
        'whereisthysting'];

function follow(user, callback) {
    var page = new WebPage();
    page.open('http://mobile.twitter.com/' + user, function (status) {
        if (status === 'fail') {
            console.log(user + ': ?');
        } else {
            var data = page.evaluate(function () {
                return document.querySelector('div.timeline-following').innerText;
            });
            console.log(user + ': ' + data);
        }
        callback.apply();
    });
}

function process() {
    if (users.length > 0) {
        var user = users[0];
        users.splice(0, 1);
        follow(user, process);
    } else {
        phantom.exit();
    }
}

process();
