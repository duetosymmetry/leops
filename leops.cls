\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{leops}[2024/01/16 Leo's problem set v2]

\RequirePackage{xkeyval}
\RequirePackage{kvoptions}
\RequirePackage{kvsetkeys}

\SetupKeyvalOptions{%
  family=LPS,%
  prefix=LPS@%
}

% The user can \def\solutionmode{} before loading the package in order
% to change the default value of solutions=true or false. This allows
% you to use the same file, without setting solutions at all, in two
% files, to make one file be solutions and the other only questions.
% Default values for keyword solutions:
%   - When the macro \solutionmode is defined before we're loaded,
%     default false
%  -  When the macro \ifstandalone is defined and is true,
%     default true
%  -  All other cases, default false
% But of course the user can pass a keyval, which overrides the default.
\@ifundefined{solutionmode}
{% Not forced into solutionmode... check to see if we were loaded by class standalone
  \@ifundefined{ifstandalone}
  {\DeclareBoolOption[false]{solutions}}
  {\ifstandalone
      \DeclareBoolOption[true]{solutions}
    \else
      % I'm not sure how we can get to this branch... but still.
      \DeclareBoolOption[false]{solutions}
    \fi}}
{\DeclareBoolOption[true]{solutions}}

\DeclareStringOption[{UNIVERSITY OF MISSISSIPPI}]{schoolname}
\DeclareStringOption[{Department of Physics and Astronomy}]{deptname}
\DeclareStringOption[{Grad Electromagnetism I}]{coursename}
\DeclareStringOption[{Phys.~721}]{coursenum}
\DeclareStringOption[{Spring 2024}]{termyear}
\DeclareStringOption[{Prof.\ Leo~C.~Stein}]{instructor}

\DeclareStringOption[01]{psnum}
\DeclareStringOption[{Monday, Jan.~31, 2022, by 11:59PM}]{psdue}


\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessKeyvalOptions*

% This allows the user to set the parameters later, for example
% \pssetup{solutions=false}
% or
% \pssetup{psdue={Some other day}}
\def\pssetup{\kvsetkeys{LPS}}
% shortcuts
\newcommand{\showsolutions}{\pssetup{solutions=true}}
\newcommand{\hidesolutions}{\pssetup{solutions=false}}

%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%\ProcessOptions\relax

%% Base class is article
\LoadClass{article}

\RequirePackage[margin=1in]{geometry}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{amsthm}
\RequirePackage{mathrsfs}
\RequirePackage{xcolor}
\RequirePackage{bbm}
\RequirePackage{slashed}
\RequirePackage{tabularx}

% UTF8 always!
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage{microtype}

% To be able to [resume] an enumerate
\RequirePackage{enumitem}

% Better page numbering
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.4pt}
\fancyhead{}
\cfoot{Page \thepage\ of \pageref*{LastPage} }

% for good coloured links
\RequirePackage[unicode, colorlinks, allcolors=blue!70!black, linktocpage, pdfusetitle]{hyperref}
\RequirePackage[all]{hypcap}

\RequirePackage{graphicx}
\RequirePackage{bm} % boldmath

\RequirePackage{ifthen}
\RequirePackage{verbatim}
\RequirePackage{caption}
\RequirePackage{subfig}

% For colored boxes
\RequirePackage[tikz]{mdframed}
\newmdenv[roundcorner=10pt,
          linecolor=gray!15,
          backgroundcolor=gray!15]{solframe}

% More TikZ stuff
\RequirePackage{tikz}
\usetikzlibrary{calc, arrows, arrows.meta, decorations.pathreplacing,
  backgrounds}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Have a different counter for equations within a solution env
%% See discussion at https://tex.stackexchange.com/a/530828/34063
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{eqtemp} % For storing ordinary eq counter
\newcounter{soleq}  % For eq counter during solution mode

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% We will use amsthm to number our exercises (then we can number
%% equations within them)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% See discussion in http://www.ams.org/arc/tex/amscls/amsthdoc.pdf
% about theorems beginning with lists, which messes up spacing
% When starting an exercise with an enum, we should do this:
% \begin{exercise}[...]
%   \leavevmode \vspace{-\baselineskip}
%   \begin{enumerate}
%     \item ...
%   \end{enumerate}
% \begin{exercise}

\newtheoremstyle{probstyle}%
  {}{}%
  {}{}%
  {\bfseries}{.}%
  {\newline}% 
  {\thmname{#1}\thmnumber{ #2}\thmnote{: #3}}
\theoremstyle{probstyle}
\newtheorem{exercise}{Problem}
\numberwithin{equation}{exercise}

\newcommand{\LPS@advanceenumlev}{\advance\@enumdepth\@ne}
\newcommand{\LPS@retractenumlev}{\advance\@enumdepth\m@ne}

\AtBeginEnvironment{exercise}{\LPS@advanceenumlev}
\AtEndEnvironment{exercise}{\LPS@retractenumlev}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% The following commands are for inserting solutions. They test the
%% value of LPS@solutions, which can be (re)set by e.g.
%% \pssetup{solutions=true}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{solution}[1][Solution:]
{\ifLPS@solutions%
\setcounter{eqtemp}{\value{equation}}% Back up equation counter
\setcounter{equation}{\value{soleq}}% Restore solution eq number
\renewcommand\theequation{S\arabic{equation}}% Change the formatting
\let\backuptheHequation\theHequation% Save the contents of the \theHequation
\renewcommand\theHequation{S.\arabic{equation}}% For hyperref
\solframe% Start the solframe env; can't use \begin{} in here
\textbf{\emph{#1}} % A paragraph started by Solution:
\else%
\comment% In this case it's a comment (requires verbatim)
\fi}
{\ifLPS@solutions%
\endsolframe% end the solframe env
\setcounter{soleq}{\value{equation}}% Back up sol eq counter
\setcounter{equation}{\value{eqtemp}}% Restore main eq number
\renewcommand\theequation{\arabic{equation}}% Restore eq formatting
\let\theHequation\backuptheHequation% Restore \theHequation
\else%
\endcomment%
\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Commands for making the pset header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\makeheader}{
\begin{center}
{\bf \LPS@schoolname} \\
\LPS@deptname\\
\LPS@coursename\ (\LPS@coursenum) --- \LPS@instructor\ --- \LPS@termyear \\
\end{center}

\vskip 0.2in

\begin{center}
\ifLPS@solutions
{\bf Problem Set \LPS@psnum\ --- SOLUTIONS}
\else
{\bf Problem Set \LPS@psnum}
\fi
\\

\vskip 0.2in

{\bf Due}: \LPS@psdue\\
\end{center}
}


% User-defined macros.

\newcommand{\bs}[1]{\boldsymbol{#1}}

\newcommand{\pd}{\partial}
\newcommand{\nn}{\nonumber}

\newcommand{\cd}{\nabla}

\newcommand{\avg}[1]{\left\langle{}#1\right\rangle}

\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator{\sign}{sign}
\DeclareMathOperator{\Tr}{Tr}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\endinput