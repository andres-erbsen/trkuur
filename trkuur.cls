\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trkuur}[2011/09/01 TRK Uurimuste class]

% Enable simple draft mode (from clsguide)
\DeclareOption{draft}{\setlength{\overfullrule}{5pt}}
\ProcessOptions\relax

% xelatex conditional
\newif\ifxelatex
  \ifx\XeTeXglyph\undefined
    \xelatexfalse
  \else
    \xelatextrue
  \fi

%                                              Numbrite vahel ja lõpus on punkt.
\LoadClass[a4paper,oneside,12pt,headings=small,numbers=enddot]{scrreprt}

% scriptimismacrod
\usepackage{etoolbox}

% Me tahame kirjutada eesti keeles ja kasutada ka mitteameerikalikke tähti
\ifxelatex
  \usepackage[estonian]{polyglossia}
\else
  \usepackage[utf8]{inputenc}
  \usepackage[estonian]{babel}
\fi

% tühjad ääred
\usepackage[top=2.54cm, bottom=2.54cm, left=3.5cm, right=1.5cm]{geometry}

% Sisukorras ja viidetel on lingid
\usepackage{hyperref}
\hypersetup{
    colorlinks,
    citecolor=black,
    filecolor=black,
    linkcolor=black,
    urlcolor=black
}

% Leheküljenumbrid algavad pärast esimest pealkirja, pealkirjaga leht on tühi
\renewcommand\thepage{}
\newtoggle{nummerdamelehti}
\togglefalse{nummerdamelehti}

% Käsk nummerdamise alustamiseks
\newcommand{\nummerdame}{%
  \iftoggle{nummerdamelehti}{}{%
    \renewcommand\thepage{\arabic{page}}%
    \toggletrue{nummerdamelehti}%
    \thispagestyle{empty}%
  }
}

% Esimese peatüki juures hakkame nummerdama
\patchcmd{\addchap}{\secdef}{\nummerdame\secdef}{}{}
\pretocmd{\chapter}{\nummerdame{}}{}{}

%% Tiitellehe genereerimine
% muutujad
\def\pealkiri#1{\gdef\@title{#1}}
\def\autor#1{\gdef\@author{#1}}
\def\klass#1{\gdef\@klass{#1}}
\def\juhendaja#1{\gdef\@juhendaja{#1}}
\def\asutus#1{\gdef\@asutus{#1}}
\def\paber#1{\gdef\@paber{#1}}
\def\koht#1{\gdef\@koht{#1}}

% vaikeväärtused
\paber{Uurimist\"o\"o}
\asutus{Tallinna Reaalkool}
\koht{Tallinn}

\renewcommand{\maketitle}{\newpage%
	\thispagestyle{empty}
	\vspace*{0cm}
	\Large
	\begin{center}
        \expandafter{\@asutus} \\
	\end{center}

	\vfill

	\begin{center}
		\huge\expandafter{\@title}
	\end{center}
	\centerline{\@paber}

	\vskip.5in
	\vfill
	
	\begin{flushright}
	\large{
		\expandafter{\@author} \\
		\expandafter{\@klass} \\
		Juhendaja: \expandafter{\@juhendaja}
		}
	\end{flushright}
	\vskip.5in

	\normalsize

	\vfill
	\centerline{\@koht{} \the\year}%
	\clearpage
	}


\usepackage{tocloft}
% jaotuste numbrite taga on punktid
\renewcommand{\cftchapaftersnum}{.}
\renewcommand{\cftsecaftersnum}{.}
\renewcommand{\cftsubsecaftersnum}{.}
\renewcommand{\cftsubsubsecaftersnum}{.}
% sisukorras on osade pealkirjade taga punktiir, nagu muudel pealkirjadel
\renewcommand{\cftchapdotsep}{\cftdotsep}

%Näitame kõikide - ka väga madala taseme - jaotuste pealkirju
\setcounter{tocdepth}{99}
% numbreid ka neile
\setcounter{secnumdepth}{99}

% Lisade pealkirjad stiilis "Lisa 2 Teise lisa pealkiri"
\newcommand{\lisa}[1]{%
	\addtocounter{chapter}{1}%
	\addchap{Lisa \thechapter\enskip#1}%
	\setcounter{section}{0}%
	}

% pärast käsu \appendix kasutamist lisatakse peatüki asemel lisa.
\let\origappendix\appendix
\renewcommand{\appendix}{%
	\setcounter{chapter}{0}
	\let\chapter\lisa%
%	\let\section\lisa%
	\let\subsection\section%
	\let\subsubsection\section%
	}

%% Loetelud ja listid tihedamini kokku
%%% HACK: reimplement \AtBeginEnvironment for scribtex compatability
\patchcmd\begin
  {\csname #1\endcsname}
  {\csuse{@begin@#1@hook}%
   \csname #1\endcsname}
  {}
  {\etb@warning{%
     Patching '\string\begin' failed!\MessageBreak
     '\string\AtBeginEnvironment' will not work\@gobble}}

\csgappto{@begin@enumerate@hook}{%
    \setlength{\itemsep}{0pt}%
    \setlength{\parskip}{1mm}%
    \setlength{\parsep}{0pt}%
  }

\csgappto{@begin@itemize@hook}{%
    \setlength{\itemsep}{0pt}%
    \setlength{\parskip}{1mm}%
    \setlength{\parsep}{0pt}%
  }

\csgappto{@begin@description@hook}{%
    \setlength{\itemsep}{0pt}%
    \setlength{\parskip}{1mm}%
    \setlength{\parsep}{0pt}%
  }

  
\usepackage{enumitem}
\setlist{itemsep=0.1mm}

%% tabelid ja joonised

% Jooniste (ja tabelite?) keskjoondus
% \makeatletter
% \def\@floatboxreset{%
% \reset@font
% \normalsize
% \@setminipage
% \centering}
% \makeatother

% tabelite ja jooniste numbrite taha koolonit ei pane
\usepackage[justification=justified,singlelinecheck=false]{caption}
\newcommand{\trkcaptionsetup}{\captionsetup{labelformat=simple, labelsep=period, labelfont=bf, font=bf}}
\trkcaptionsetup

% Töö kõik tabelid tuleb nummerdada läbiva numeratsiooniga (ja kui juba tabelid, siis muu ka vist)
\usepackage{chngcntr}
\counterwithout{figure}{chapter}
\counterwithout{table}{chapter}
\counterwithout{equation}{chapter}
\counterwithout{footnote}{chapter}

% tabeli (alla) allika lisamise käsk
\newcommand{\captionstosource}{\captionsetup{labelformat=simple, labelsep=period, font=normalfont}}
\newcommand{\allikas}[1]{\vspace{-3mm}\captionstosource\caption*{Allikas: #1}\trkcaptionsetup}

%% Pealkirjade välimus
\usepackage{sectsty} % still needed? For xelatex too?

% Times New Roman and Arial all over the paper
% \usepackage{mathtime} % times-based math font
\ifxelatex
  \usepackage{xltxtra} % is this neccessary?
  \setmainfont{Times New Roman} % [Mapping=tex-text]
  \setsansfont{Arial} % Pealkirjad Arial
  % Pealkiri 1: normaallaad + Font: Arial, 16pt., paks, joondatud lehe vasakusse serva).
  \chapterfont{\fontsize{16pt}{19.2pt}\selectfont}
  % Madalama taseme (alajaotuste) pealkirjad on väiksemad, võib kasutada arvuti poolt vaikimisi pakutavaid erineva taseme pealkirju.
  \sectionfont{\fontsize{14pt}{16.8pt}\selectfont}
\else
  \usepackage[T1]{fontenc}
  \usepackage{times}
  \allsectionsfont{\fontfamily{phv}\selectfont} % Pealkirjad (peaaegu) Arial 
  % Pealkiri 1: normaallaad + Font: Arial, 16pt., paks, joondatud lehe vasakusse serva).
  \chapterfont{\fontsize{16pt}{19.2pt}\fontfamily{phv}\selectfont}
  % Madalama taseme (alajaotuste) pealkirjad on väiksemad, võib kasutada arvuti poolt vaikimisi pakutavaid erineva taseme pealkirju.
  \sectionfont{\fontsize{14pt}{16.8pt}\fontfamily{phv}\selectfont}
\fi

%% Lõigud ja tekst
% Reavahe on 1,5
\usepackage{setspace}
\onehalfspacing

% Punkti järel ei ole meil pikka tühikut, isegi kui kohalik LaTeX nii arvab vaikimisi.
\frenchspacing

% Taandridasid pole
\setlength{\parindent}{0pt}

% lõiguvahe 12pt, aga pärast uut alajaoutist hoiame ruumi kokku.
\usepackage{titlesec}
\setparsizes{\parindent}{16.5pt}{\parfillskip}
\renewcommand*{\chapterheadendvskip}{\vspace{-3mm}}
\titlespacing*{\section}{0pt}{1mm}{-3mm}
\titlespacing*{\subsection}{0pt}{1mm}{-3mm}
\titlespacing*{\subsubsection}{0pt}{1mm}{-3mm}

\usepackage{graphicx} % piltide tugi
\usepackage[style=trkuur]{biblatex} % kasutatud kirjanduse haldamise laadimine
\defbibheading{bibliography}{\addchap{#1}} % lisame kasutatud kirjanduse sisukorda

%% trkuur formaadilt report peale üle minemiseks lisage algusse:
%% mõned tiitellehe väljad tuleb ka välja kommenteerida
%\usepackage{graphicx} % piltide tugi
%\usepackage{biblatex} % kasutatud kirjanduse haldamise laadimine
%\newcommand{\allikas}[1]{\hfill{}{#1}\hfill{}}
%\let\addchap\chapter % seda pole KOMA-script juures vaja, seal juba ok, mujal ikka.