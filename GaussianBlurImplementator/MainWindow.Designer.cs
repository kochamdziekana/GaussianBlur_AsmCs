namespace GaussianBlurImplementator
{
    partial class MainWindow
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.btnBlur = new System.Windows.Forms.Button();
            this.txtFilename = new System.Windows.Forms.TextBox();
            this.btnChooseBmp = new System.Windows.Forms.Button();
            this.chBoxLanguageAsm = new System.Windows.Forms.CheckBox();
            this.chBoxLanguageCs = new System.Windows.Forms.CheckBox();
            this.picBoxAfter = new System.Windows.Forms.PictureBox();
            this.picBoxBefore = new System.Windows.Forms.PictureBox();
            this.radioButton64 = new System.Windows.Forms.RadioButton();
            this.radioButton32 = new System.Windows.Forms.RadioButton();
            this.radioButton16 = new System.Windows.Forms.RadioButton();
            this.radioButton8 = new System.Windows.Forms.RadioButton();
            this.radioButton4 = new System.Windows.Forms.RadioButton();
            this.radioButton2 = new System.Windows.Forms.RadioButton();
            this.radioButton1 = new System.Windows.Forms.RadioButton();
            this.lblThreads = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lblTime = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnBenchmark = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxAfter)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxBefore)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Tahoma", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label1.Location = new System.Drawing.Point(474, 17);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(167, 25);
            this.label1.TabIndex = 3;
            this.label1.Text = "Wybierz język:";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // btnBlur
            // 
            this.btnBlur.BackColor = System.Drawing.Color.LimeGreen;
            this.btnBlur.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnBlur.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnBlur.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnBlur.Location = new System.Drawing.Point(474, 211);
            this.btnBlur.Name = "btnBlur";
            this.btnBlur.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.btnBlur.Size = new System.Drawing.Size(167, 54);
            this.btnBlur.TabIndex = 15;
            this.btnBlur.Text = "Rozmyj";
            this.btnBlur.UseVisualStyleBackColor = false;
            this.btnBlur.Click += new System.EventHandler(this.btnBlur_Click);
            // 
            // txtFilename
            // 
            this.txtFilename.BackColor = System.Drawing.Color.LightSkyBlue;
            this.txtFilename.Location = new System.Drawing.Point(428, 157);
            this.txtFilename.Name = "txtFilename";
            this.txtFilename.Size = new System.Drawing.Size(247, 23);
            this.txtFilename.TabIndex = 14;
            // 
            // btnChooseBmp
            // 
            this.btnChooseBmp.BackColor = System.Drawing.Color.LimeGreen;
            this.btnChooseBmp.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnChooseBmp.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnChooseBmp.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnChooseBmp.Location = new System.Drawing.Point(474, 97);
            this.btnChooseBmp.Name = "btnChooseBmp";
            this.btnChooseBmp.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.btnChooseBmp.Size = new System.Drawing.Size(167, 54);
            this.btnChooseBmp.TabIndex = 13;
            this.btnChooseBmp.Text = "Wybierz obraz do rozmycia";
            this.btnChooseBmp.UseVisualStyleBackColor = false;
            this.btnChooseBmp.Click += new System.EventHandler(this.btnChooseBmp_Click);
            // 
            // chBoxLanguageAsm
            // 
            this.chBoxLanguageAsm.AutoSize = true;
            this.chBoxLanguageAsm.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.chBoxLanguageAsm.Location = new System.Drawing.Point(573, 57);
            this.chBoxLanguageAsm.Name = "chBoxLanguageAsm";
            this.chBoxLanguageAsm.Size = new System.Drawing.Size(102, 25);
            this.chBoxLanguageAsm.TabIndex = 12;
            this.chBoxLanguageAsm.Text = "Assembler";
            this.chBoxLanguageAsm.UseVisualStyleBackColor = true;
            this.chBoxLanguageAsm.CheckedChanged += new System.EventHandler(this.chBoxLanguage_CheckedChanged);
            // 
            // chBoxLanguageCs
            // 
            this.chBoxLanguageCs.AutoSize = true;
            this.chBoxLanguageCs.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.chBoxLanguageCs.Location = new System.Drawing.Point(474, 57);
            this.chBoxLanguageCs.Name = "chBoxLanguageCs";
            this.chBoxLanguageCs.Size = new System.Drawing.Size(61, 25);
            this.chBoxLanguageCs.TabIndex = 11;
            this.chBoxLanguageCs.Text = "C++";
            this.chBoxLanguageCs.UseVisualStyleBackColor = true;
            this.chBoxLanguageCs.CheckedChanged += new System.EventHandler(this.chBoxLanguage_CheckedChanged);
            // 
            // picBoxAfter
            // 
            this.picBoxAfter.Location = new System.Drawing.Point(681, 12);
            this.picBoxAfter.Name = "picBoxAfter";
            this.picBoxAfter.Size = new System.Drawing.Size(396, 317);
            this.picBoxAfter.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxAfter.TabIndex = 17;
            this.picBoxAfter.TabStop = false;
            // 
            // picBoxBefore
            // 
            this.picBoxBefore.Location = new System.Drawing.Point(26, 12);
            this.picBoxBefore.Name = "picBoxBefore";
            this.picBoxBefore.Size = new System.Drawing.Size(396, 317);
            this.picBoxBefore.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.picBoxBefore.TabIndex = 16;
            this.picBoxBefore.TabStop = false;
            // 
            // radioButton64
            // 
            this.radioButton64.AutoSize = true;
            this.radioButton64.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton64.Location = new System.Drawing.Point(666, 454);
            this.radioButton64.Name = "radioButton64";
            this.radioButton64.Size = new System.Drawing.Size(36, 23);
            this.radioButton64.TabIndex = 35;
            this.radioButton64.TabStop = true;
            this.radioButton64.Text = "1";
            this.radioButton64.UseVisualStyleBackColor = true;
            this.radioButton64.CheckedChanged += new System.EventHandler(this.radioButton64_CheckedChanged);
            // 
            // radioButton32
            // 
            this.radioButton32.AutoSize = true;
            this.radioButton32.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton32.Location = new System.Drawing.Point(624, 454);
            this.radioButton32.Name = "radioButton32";
            this.radioButton32.Size = new System.Drawing.Size(36, 23);
            this.radioButton32.TabIndex = 34;
            this.radioButton32.TabStop = true;
            this.radioButton32.Text = "1";
            this.radioButton32.UseVisualStyleBackColor = true;
            this.radioButton32.CheckedChanged += new System.EventHandler(this.radioButton32_CheckedChanged);
            // 
            // radioButton16
            // 
            this.radioButton16.AutoSize = true;
            this.radioButton16.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton16.Location = new System.Drawing.Point(584, 454);
            this.radioButton16.Name = "radioButton16";
            this.radioButton16.Size = new System.Drawing.Size(36, 23);
            this.radioButton16.TabIndex = 33;
            this.radioButton16.TabStop = true;
            this.radioButton16.Text = "1";
            this.radioButton16.UseVisualStyleBackColor = true;
            this.radioButton16.CheckedChanged += new System.EventHandler(this.radioButton16_CheckedChanged);
            // 
            // radioButton8
            // 
            this.radioButton8.AutoSize = true;
            this.radioButton8.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton8.Location = new System.Drawing.Point(542, 454);
            this.radioButton8.Name = "radioButton8";
            this.radioButton8.Size = new System.Drawing.Size(36, 23);
            this.radioButton8.TabIndex = 32;
            this.radioButton8.TabStop = true;
            this.radioButton8.Text = "1";
            this.radioButton8.UseVisualStyleBackColor = true;
            this.radioButton8.CheckedChanged += new System.EventHandler(this.radioButton8_CheckedChanged);
            // 
            // radioButton4
            // 
            this.radioButton4.AutoSize = true;
            this.radioButton4.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton4.Location = new System.Drawing.Point(500, 454);
            this.radioButton4.Name = "radioButton4";
            this.radioButton4.Size = new System.Drawing.Size(36, 23);
            this.radioButton4.TabIndex = 31;
            this.radioButton4.TabStop = true;
            this.radioButton4.Text = "1";
            this.radioButton4.UseVisualStyleBackColor = true;
            this.radioButton4.CheckedChanged += new System.EventHandler(this.radioButton4_CheckedChanged);
            // 
            // radioButton2
            // 
            this.radioButton2.AutoSize = true;
            this.radioButton2.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton2.Location = new System.Drawing.Point(458, 454);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.Size = new System.Drawing.Size(36, 23);
            this.radioButton2.TabIndex = 30;
            this.radioButton2.TabStop = true;
            this.radioButton2.Text = "1";
            this.radioButton2.UseVisualStyleBackColor = true;
            this.radioButton2.CheckedChanged += new System.EventHandler(this.radioButton2_CheckedChanged);
            // 
            // radioButton1
            // 
            this.radioButton1.AutoSize = true;
            this.radioButton1.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.radioButton1.Location = new System.Drawing.Point(416, 454);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.Size = new System.Drawing.Size(36, 23);
            this.radioButton1.TabIndex = 29;
            this.radioButton1.TabStop = true;
            this.radioButton1.Text = "1";
            this.radioButton1.UseVisualStyleBackColor = true;
            this.radioButton1.CheckedChanged += new System.EventHandler(this.radioButton1_CheckedChanged);
            // 
            // lblThreads
            // 
            this.lblThreads.AutoSize = true;
            this.lblThreads.BackColor = System.Drawing.Color.LightSkyBlue;
            this.lblThreads.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.lblThreads.Location = new System.Drawing.Point(642, 416);
            this.lblThreads.Name = "lblThreads";
            this.lblThreads.Size = new System.Drawing.Size(18, 19);
            this.lblThreads.TabIndex = 28;
            this.lblThreads.Text = "4";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Tahoma", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label3.Location = new System.Drawing.Point(416, 411);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(163, 25);
            this.label3.TabIndex = 25;
            this.label3.Text = "Ilość wątków:";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblTime
            // 
            this.lblTime.AutoSize = true;
            this.lblTime.BackColor = System.Drawing.Color.LightSkyBlue;
            this.lblTime.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.lblTime.Location = new System.Drawing.Point(539, 368);
            this.lblTime.Name = "lblTime";
            this.lblTime.Size = new System.Drawing.Size(40, 19);
            this.lblTime.TabIndex = 24;
            this.lblTime.Text = "time";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Tahoma", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point);
            this.label2.Location = new System.Drawing.Point(428, 332);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(247, 25);
            this.label2.TabIndex = 23;
            this.label2.Text = "Czas wykonania (ms):";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // btnBenchmark
            // 
            this.btnBenchmark.BackColor = System.Drawing.Color.LimeGreen;
            this.btnBenchmark.FlatStyle = System.Windows.Forms.FlatStyle.System;
            this.btnBenchmark.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.btnBenchmark.ForeColor = System.Drawing.SystemColors.ControlText;
            this.btnBenchmark.Location = new System.Drawing.Point(474, 491);
            this.btnBenchmark.Name = "btnBenchmark";
            this.btnBenchmark.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.btnBenchmark.Size = new System.Drawing.Size(167, 54);
            this.btnBenchmark.TabIndex = 37;
            this.btnBenchmark.Text = "Benchmark";
            this.btnBenchmark.UseVisualStyleBackColor = false;
            this.btnBenchmark.Click += new System.EventHandler(this.btnBenchmark_Click);
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1104, 557);
            this.Controls.Add(this.btnBenchmark);
            this.Controls.Add(this.radioButton64);
            this.Controls.Add(this.radioButton32);
            this.Controls.Add(this.radioButton16);
            this.Controls.Add(this.radioButton8);
            this.Controls.Add(this.radioButton4);
            this.Controls.Add(this.radioButton2);
            this.Controls.Add(this.radioButton1);
            this.Controls.Add(this.lblThreads);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.lblTime);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.picBoxAfter);
            this.Controls.Add(this.picBoxBefore);
            this.Controls.Add(this.btnBlur);
            this.Controls.Add(this.txtFilename);
            this.Controls.Add(this.btnChooseBmp);
            this.Controls.Add(this.chBoxLanguageAsm);
            this.Controls.Add(this.chBoxLanguageCs);
            this.Controls.Add(this.label1);
            this.Name = "MainWindow";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.picBoxAfter)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.picBoxBefore)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label label1;
        private Button btnBlur;
        private TextBox txtFilename;
        private Button btnChooseBmp;
        private CheckBox chBoxLanguageAsm;
        private CheckBox chBoxLanguageCs;
        private PictureBox picBoxAfter;
        private PictureBox picBoxBefore;
        private RadioButton radioButton64;
        private RadioButton radioButton32;
        private RadioButton radioButton16;
        private RadioButton radioButton8;
        private RadioButton radioButton4;
        private RadioButton radioButton2;
        private RadioButton radioButton1;
        private Label lblThreads;
        private Label label3;
        private Label lblTime;
        private Label label2;
        private Button btnBenchmark;
    }
}