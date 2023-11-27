\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{photocal}[2023/11/27 Minimalistic photo calendar class]
\LoadClass{article}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=PC,
  prefix=PC@
}
\DeclareStringOption[598mm]{width}
\DeclareStringOption[424mm]{height}
\DeclareStringOption[40mm]{sidebarWidth}
\DeclareStringOption[100mm]{captionLength}
\DeclareStringOption[1em]{dayWeekdaySep}
\DeclareStringOption[9mm]{daySep}
\DeclareStringOption{year}
\DeclareStringOption[1]{startMonth}
\ProcessKeyvalOptions*

\newlength{\calWidth}
\setlength{\calWidth}{\PC@width}
\newlength{\calHeight}
\setlength{\calHeight}{\PC@height}
\newlength{\sidebarWidth}
\setlength{\sidebarWidth}{\PC@sidebarWidth}
\newlength{\captionHeight}
\setlength{\captionHeight}{\PC@captionLength}
\newlength{\tableColumnSep}
\setlength{\tableColumnSep}{\PC@dayWeekdaySep}
\newlength{\daySep}
\setlength{\daySep}{\PC@daySep}
\newlength{\imageWidth}
\setlength{\imageWidth}{\calWidth}
\newlength{\tableColumnWidth}
\setlength{\tableColumnWidth}{.5\sidebarWidth}
\addtolength{\tableColumnWidth}{-\tableColumnSep}
\addtolength{\imageWidth}{-\sidebarWidth}
\newcounter{monthCounter}
\setcounter{monthCounter}{\PC@startMonth}
\newcounter{year}
\setcounter{year}{\PC@year}
\newlength{\imageFileWidth}
\newlength{\imageFileHeight}

\newcommand{\captionFont}{\sffamily}
\newcommand{\calFont}{\ttfamily}

\usepackage[margin=0mm, paperwidth=\calWidth, paperheight=\calHeight]{geometry}
\usepackage{tikz}
\usetikzlibrary{calendar}
\usepackage{array}
\usepackage{xcolor}
\usepackage{ifthen}
\usepackage{duckuments}

\definecolor{sidebarColor}{HTML}{000000}
\definecolor{textColor}{HTML}{FFFFFF}
\definecolor{highlightTextColor}{HTML}{AAAAAA}

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

\def\monthName#1{\ifcase#1\or JAN\or FEB\or MAR\or APR\or MAY\or JUN\or JUL\or AUG\or SEP\or OCT\or NOV\or DEC\fi}
\def\dayName#1{\ifcase #1 Mo\or Tu\or We\or Th\or Fr\or Sa\or Su\fi}

\newcommand{\calendarium}{
    \node[anchor=center, textColor, font=\captionFont] at ([xshift=-\sidebarWidth/2, yshift=-\captionHeight-3em]current page.north east) {\huge\monthName{\themonthCounter}};
    \node at ([xshift=-\sidebarWidth/2, yshift=-\calHeight/2-\captionHeight/2]current page.north east) {
            \begin{tikzpicture}
                \calendar [dates=\theyear-\themonthCounter-01 to \theyear-\themonthCounter-last,
                    day list downward,
                    day yshift=\daySep,
                    font = \calFont,
                    color = textColor,
                    day text={\begin{tabular}%
                                {R{\tableColumnWidth}@{\hskip\tableColumnSep}L{\tableColumnWidth}}%
                                {\Large \%d-} & \textbf{\dayName{\pgfcalendarcurrentweekday}} %
                            \end{tabular}}]
                if (weekend)
                [highlightTextColor,nodes={draw=none}];
            \end{tikzpicture}
        };
    \stepcounter{monthCounter}
}

\define@key{calPage}{anchor}{\def\cp@anchor{#1}}
\define@key{calPage}{cal}{\def\cp@cal{#1}}
\define@key{calPage}{photo}{\def\cp@photo{#1}}
\setkeys{calPage}{anchor=center,cal=true,photo=example-image-duck}%

\DeclareDocumentEnvironment{page}{O{}}{%
    \setkeys{calPage}{#1}
    \settowidth{\imageFileWidth}{\includegraphics{\cp@photo}}%
    \settoheight{\imageFileHeight}{\includegraphics{\cp@photo}}%
    \noindent\begin{tikzpicture}[remember picture,overlay]
        \coordinate (image north east) at ([xshift=-\sidebarWidth]current page.north east);
        \coordinate (image south east) at ([xshift=-\sidebarWidth]current page.south east);
        \coordinate (image north west) at (current page.north west);
        \coordinate (image south west) at (current page.south west);
        \coordinate (image center) at ([xshift=-\sidebarWidth/2]current page.center);
        \node[anchor=\cp@anchor,inner sep=0pt] at (image \cp@anchor) {%
        \ifnum\fpeval{\the\imageFileWidth/\the\imageFileHeight > \the\imageWidth/\the\calHeight}=1%
             \includegraphics[height=\calHeight,keepaspectratio=true]{\cp@photo}%
        \else%
            \includegraphics[width=\imageWidth,keepaspectratio=true]{\cp@photo}%
        \fi%
        }; 
        \fill[sidebarColor] (current page.north east) rectangle ++(-\sidebarWidth,-\calHeight);
        \draw[textColor, line width=0.5mm] ([xshift=-0.1\sidebarWidth, yshift=-\captionHeight]current page.north east) -- ++(-0.8\sidebarWidth,0);
        \ifthenelse{\equal{\cp@cal}{true}}{
            \calendarium
        }{}
        }%
        {\end{tikzpicture}%
        \newpage}

\renewcommand{\caption}[1]{\node[rotate=-90, anchor=center, textColor, font=\captionFont] at ([xshift=-\sidebarWidth/2, yshift=-\captionHeight/2]current page.north east) {\Huge #1};}

\newcommand{\subcaption}[1]{
    \node[rotate=-90, anchor=center, textColor, font=\captionFont] at ([xshift=-\sidebarWidth/2, yshift=-\calHeight/2-\captionHeight/2]current page.north east) {\huge #1};
}