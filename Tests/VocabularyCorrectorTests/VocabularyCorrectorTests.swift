import Testing
import VocabularyCorrector

@Suite("VocabularyCorrector")
struct VocabularyCorrectorTests {
    @Test("exact match is not replaced")
    func exactMatch() {
        let result = VocabularyCorrector.correct(
            text: "run kubectl apply",
            vocabulary: ["kubectl"]
        )
        #expect(result == "run kubectl apply")
    }

    @Test("edit distance 1 corrected")
    func editDistance1() {
        let result = VocabularyCorrector.correct(
            text: "run kubctl apply",
            vocabulary: ["kubectl"]
        )
        #expect(result == "run kubectl apply")
    }

    @Test("edit distance 2 corrected for long words")
    func editDistance2() {
        let result = VocabularyCorrector.correct(
            text: "run terrafurn apply",
            vocabulary: ["terraform"]
        )
        #expect(result == "run terraform apply")
    }

    @Test("short words require closer match")
    func shortWordDistance2NotCorrectedToVocabulary() {
        let result = VocabularyCorrector.correct(
            text: "make sure it works",
            vocabulary: ["sudo"]
        )
        #expect(result == "make sure it works")
    }

    @Test("short words with deletion and substitution are not corrected")
    func shortWordDistance2DeletionSubstitutionNotCorrectedToVocabulary() {
        let result = VocabularyCorrector.correct(
            text: "we should just reuse it",
            vocabulary: ["jud"]
        )
        #expect(result == "we should just reuse it")
    }

    @Test("genuine short edit distance 1 correction still applies")
    func shortWordDistance1StillCorrected() {
        let result = VocabularyCorrector.correct(
            text: "use sudp carefully",
            vocabulary: ["sudo"]
        )
        #expect(result == "use sudo carefully")
    }

    @Test("edit distance 3 not corrected")
    func editDistance3TooFar() {
        let result = VocabularyCorrector.correct(
            text: "run kubexyz apply",
            vocabulary: ["kubectl"]
        )
        #expect(result == "run kubexyz apply")
    }

    @Test("empty vocabulary returns original text")
    func emptyVocabulary() {
        let result = VocabularyCorrector.correct(
            text: "hello world",
            vocabulary: []
        )
        #expect(result == "hello world")
    }

    @Test("empty text returns empty")
    func emptyText() {
        let result = VocabularyCorrector.correct(
            text: "",
            vocabulary: ["kubectl"]
        )
        #expect(result.isEmpty)
    }

    @Test("case insensitive exact match is not replaced")
    func caseInsensitiveExactMatch() {
        let result = VocabularyCorrector.correct(
            text: "run Pytest now",
            vocabulary: ["pytest"]
        )
        #expect(result == "run Pytest now")
    }

    @Test("case insensitive near-match is corrected to vocabulary casing")
    func caseInsensitiveNearMatch() {
        let result = VocabularyCorrector.correct(
            text: "run Pytst now",
            vocabulary: ["pytest"]
        )
        #expect(result == "run pytest now")
    }

    @Test("multiple corrections in one pass")
    func multipleCorrections() {
        let result = VocabularyCorrector.correct(
            text: "use sudoo to run pipenv",
            vocabulary: ["sudo", "pipenv"]
        )
        #expect(result == "use sudo to run pipenv")
    }

    @Test("short words are not corrected to avoid false positives")
    func shortWordsSkipped() {
        let result = VocabularyCorrector.correct(
            text: "run the gat cmd",
            vocabulary: ["git", "cat", "get", "cmd"]
        )
        #expect(result == "run the gat cmd")
    }

    @Test("editDistance utility is correct")
    func editDistanceBasics() {
        #expect(VocabularyCorrector.editDistance("kitten", "sitting") == 3)
        #expect(VocabularyCorrector.editDistance("", "abc") == 3)
        #expect(VocabularyCorrector.editDistance("abc", "") == 3)
        #expect(VocabularyCorrector.editDistance("abc", "abc") == 0)
        #expect(VocabularyCorrector.editDistance("kubectl", "kubctl") == 1)
    }
}
