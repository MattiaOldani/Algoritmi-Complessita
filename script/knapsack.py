import math
import numpy as np


def generate_instance(n, mx=100):
    values = np.random.choice(range(1, mx), size=n).tolist()
    weights = np.random.choice(range(1, mx), size=n).tolist()
    wMax = max(weights)
    W = np.random.randint(wMax, 2 * wMax)

    return sorted(list(zip(values, weights)), key=lambda x: x[0]), W


def dynamic_W(vw, W):
    n = len(vw)
    A = np.zeros((W + 1, n + 1), int)
    B = [[[] for _ in range(n + 1)] for _ in range(W + 1)]

    for i in range(n + 1):
        A[0][i] = 0
    for w in range(W + 1):
        A[w][0] = 0

    for w in range(1, W + 1):
        for i in range(1, n + 1):
            if w < vw[i - 1][1]:
                A[w][i] = A[w][i - 1]
                B[w][i] = B[w][i - 1]
            else:
                if A[w][i - 1] > vw[i - 1][0] + A[w - vw[i - 1][1]][i - 1]:
                    A[w][i] = A[w][i - 1]
                    B[w][i] = B[w][i - 1]
                else:
                    A[w][i] = vw[i - 1][0] + A[w - vw[i - 1][1]][i - 1]
                    B[w][i] = B[w - vw[i - 1][1]][i - 1] + [i - 1]

    return int(A[W][n]), B[W][n]


def dynamic_V(vw, W):
    n = len(vw)
    sv = sum([x[0] for x in vw])
    A = np.zeros((sv + 1, n + 1), float)
    B = [[[] for _ in range(n + 1)] for _ in range(sv + 1)]

    for i in range(n + 1):
        A[0][i] = 0
    for v in range(1, sv + 1):
        A[v][0] = float("inf")

    for v in range(1, sv + 1):
        for i in range(1, n + 1):
            if v < vw[i - 1][0]:
                if A[v][i - 1] < vw[i - 1][1]:
                    A[v][i] = A[v][i - 1]
                    B[v][i] = B[v][i - 1]
                else:
                    A[v][i] = vw[i - 1][1]
                    B[v][i] = [i - 1]
            else:
                if A[v][i - 1] < vw[i - 1][1] + A[v - vw[i - 1][0]][i - 1]:
                    A[v][i] = A[v][i - 1]
                    B[v][i] = B[v][i - 1]
                else:
                    A[v][i] = vw[i - 1][1] + A[v - vw[i - 1][0]][i - 1]
                    B[v][i] = B[v - vw[i - 1][0]][i - 1] + [i - 1]

    for v in range(sv, 0, -1):
        if A[v][n] <= W:
            return v, B[v][n]


def fptas(vw, W, epsilon):
    n = len(vw)
    theta = max(epsilon * max([x[0] for x in vw]) / (2 * n), 1)
    vw_hat = [(math.ceil(couple[0] / theta), couple[1]) for couple in vw]

    _, B_hat = dynamic_V(vw_hat, W)

    return sum([vw[i][0] for i in B_hat]), B_hat


def main():
    vw, W = generate_instance(50, mx=1000)

    print("Istanza del problema")
    print(f"Valore e peso degli oggetti: {vw}")
    print(f"Peso dello zaino: {W}")

    print()

    V, B = dynamic_W(vw, W)
    print("Soluzione con focus pesi")
    print(f"Valore degli oggetti scelti: {V}")
    print(f"Indici degli oggetti scelti: {B}")
    print()

    V, B = dynamic_V(vw, W)
    print("Soluzione con focus valori")
    print(f"Valore degli oggetti scelti: {V}")
    print(f"Indici degli oggetti scelti: {B}")
    print()

    V, B = fptas(vw, W, 4)
    print("Soluzione approssimata")
    print(f"Valore degli oggetti scelti: {V}")
    print(f"Indici degli oggetti scelti: {B}")


if __name__ == "__main__":
    main()
