// https://ru.wikibooks.org/wiki/%D0%A0%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8_%D0%B0%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC%D0%BE%D0%B2/%D0%91%D1%8B%D1%81%D1%82%D1%80%D0%BE%D0%B5_%D0%BF%D1%80%D0%B5%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_%D0%A4%D1%83%D1%80%D1%8C%D0%B5
// AVal - массив анализируемых данных, Nvl - длина массива должна быть кратна степени 2.
// FTvl - массив полученных значений, Nft - длина массива должна быть равна Nvl.

void FFT(float[] AVal, float[] FTvl, int Nvl, int Nft) {
  int i, j, n, m, Mmax, Istp;
  float Tmpr, Tmpi, Wtmp, Theta;
  float Wpr, Wpi, Wr, Wi;
  float[] Tmvl;

  n = Nvl * 2;
  Tmvl = new float[n];

  for (i = 0; i < n; i+=2) {
    Tmvl[i] = 0;
    Tmvl[i+1] = AVal[i/2];
  }

  i = 1; 
  j = 1;
  while (i < n) {
    if (j > i) {
      Tmpr = Tmvl[i]; 
      Tmvl[i] = Tmvl[j]; 
      Tmvl[j] = Tmpr;
      Tmpr = Tmvl[i+1]; 
      Tmvl[i+1] = Tmvl[j+1]; 
      Tmvl[j+1] = Tmpr;
    }
    i = i + 2; 
    m = Nvl;
    while ((m >= 2) && (j > m)) {
      j = j - m; 
      m = m >> 1;
    }
    j = j + m;
  }

  Mmax = 2;
  while (n > Mmax) {
    Theta = -TWO_PI / Mmax; 
    Wpi = sin(Theta);
    Wtmp = sin(Theta / 2); 
    Wpr = Wtmp * Wtmp * 2;
    Istp = Mmax * 2; 
    Wr = 1; 
    Wi = 0; 
    m = 1;

    while (m < Mmax) {
      i = m; 
      m = m + 2; 
      Tmpr = Wr; 
      Tmpi = Wi;
      Wr = Wr - Tmpr * Wpr - Tmpi * Wpi;
      Wi = Wi + Tmpr * Wpi - Tmpi * Wpr;

      while (i < n) {
        j = i + Mmax;
        Tmpr = Wr * Tmvl[j] - Wi * Tmvl[j-1];
        Tmpi = Wi * Tmvl[j] + Wr * Tmvl[j-1];

        Tmvl[j] = Tmvl[i] - Tmpr; 
        Tmvl[j-1] = Tmvl[i-1] - Tmpi;
        Tmvl[i] = Tmvl[i] + Tmpr; 
        Tmvl[i-1] = Tmvl[i-1] + Tmpi;
        i = i + Istp;
      }
    }

    Mmax = Istp;
  }

  for (i = 0; i < Nft; i++) {
    j = i * 2;
    FTvl[i] = 2*sqrt(pow(Tmvl[j], 2) + pow(Tmvl[j+1], 2))/Nvl;
  }
}
