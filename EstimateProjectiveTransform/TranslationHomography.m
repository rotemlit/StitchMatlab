function H = TranslationHomography(translation)
H = [1 0 translation(1);
     0 1 translation(2);
     0 0 1];