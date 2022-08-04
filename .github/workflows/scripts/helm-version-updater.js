module.exports.readVersion = function (contents) {
    const matcher = new RegExp("version: (.+)", "g");
    const matches = matcher.exec(contents);
    return matches[0];
}

module.exports.writeVersion = function (contents, version) {
    return contents.replaceAll(/version: .+/g, `version: ${version}`);
}
