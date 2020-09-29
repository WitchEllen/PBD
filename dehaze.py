import cv2
import guided_filter
import numpy as np

N = 255 * 255  # tiff 16-bit
Iper = cv2.imread('./data/ImageWorst_tiff16.tiff')
Ipar = cv2.imread('./data/ImageBest_tiff16.tiff')
Ipar = Ipar / N
Iper = Iper / N
Itotal = (Ipar + Iper)

m, n, o = Ipar.shape

Pr = (np.sum(Iper[:, :, 2]) - np.sum(Ipar[:, :, 2])) / (np.sum(Iper[:, :, 2]) +
                                                        np.sum(Ipar[:, :, 2]))
Pg = (np.sum(Iper[:, :, 1]) - np.sum(Ipar[:, :, 1])) / (np.sum(Iper[:, :, 1]) +
                                                        np.sum(Ipar[:, :, 1]))
Pb = (np.sum(Iper[:, :, 0]) - np.sum(Ipar[:, :, 0])) / (np.sum(Iper[:, :, 0]) +
                                                        np.sum(Ipar[:, :, 0]))

P = np.array([Pb, Pg, Pr])
A = Iper - Ipar / P

Ainfr = (np.sum(Iper[:, :, 2]) + np.sum(Ipar[:, :, 2])) / (m * n)
Ainfg = (np.sum(Iper[:, :, 1]) + np.sum(Ipar[:, :, 1])) / (m * n)
Ainfb = (np.sum(Iper[:, :, 0]) + np.sum(Ipar[:, :, 0])) / (m * n)

Ainf = np.array([Ainfb, Ainfg, Ainfr])

t = 1 - A / Ainf
a_max = np.max(t)
np.clip(t, 0.1, a_max)

r = 60
eps = 1e-6
t = guided_filter.guided_filter(Itotal, t, r, eps)

R = Itotal - A / t
cv2.imwrite('R.png', R * N)
