## 數位低通濾波器設計與模擬分析 (Digital Low-Pass Filter Design & Analysis)

### 📋 設計規格與目標 (Design Specifications)
* **通帶邊界頻率 (ω<sub>p</sub>)**：π/3
* **阻帶邊界頻率 (ω<sub>s</sub>)**：0.4π
* **直流增益 (|H(e<sup>j0</sup>)|)**：1
* **阻帶衰減要求**：|H(e<sup>j(0.4π)</sup>)| ≤ 0.01（相當於 -40 dB）
* **通帶紋波 (Passband Ripple)**：≤ 0.01

### 1. 漢寧窗 (Hann Window) 最小濾波器長度設計
* **視窗選用依據**：依據教科書規範，Hann 窗之峰值近似誤差小於 -40 dB，完全符合本專案之衰減標準。
* **實作與驗證**：透過疊代搜尋與離散時間傅立葉轉換（DTFT）定義來驗證頻率響應，精確求得滿足過渡頻寬的最小濾波器長度。

| 過渡帶詳情圖解 |
| :---: |
| ![Transition Band Detail](transition_band_detail_n46.png)<br>*圖 1：在 ω<sub>s</sub> = 0.4π 處成功達到 -40 dB 以下阻帶規格之過渡帶響應細節* |

### 2. 阻帶邊界 ω<sub>s</sub> 對濾波器階數 N 之影響
* **參數變動機制**：固定誤差要求 δ = 0.01，並將阻帶邊界 ω<sub>s</sub> 在 [0.4π, 0.5π] 區間內進行調整。
* **核心觀察**：所需之濾波器階數 N 隨 ω<sub>s</sub> 增加而呈非線性下降，並展現出顯著的階梯效應（Staircase Effect）。

| ω<sub>s</sub> 與 N 之關係趨勢 |
| :---: |
| ![Relationship between ws and N](ws_vs_n_hann.png)<br>*圖 2：隨著 ω<sub>s</sub> 逐漸遠離 ω<sub>p</sub>，濾波器階數需求獲得放寬* |

### 3. 效能對比：Hann FIR 濾波器 vs. Butterworth IIR 濾波器
* **計算效率評估**：Butterworth IIR 濾波器在達成相同 -40 dB 規格時所需的係數較少，具備較高的計算效率。
* **相位特性分析**：FIR 濾波器具備完美的線性相位（Linear Phase）特徵，能有效避免非線性相位所帶來的訊號失真。

| 頻率響應與相位響應比較 |
| :---: |
| ![Magnitude and Phase Comparison](magnitude_phase_comparison.png)<br>*圖 3：(a) 振幅響應對比；(b) 相位響應對比（突顯 FIR 濾波器之線性相位優勢）* |