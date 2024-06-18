%# Copyright (c) 2023 Christoph P. Neumann,  

%# DISCLAIMER:
%# I had to decide whether to hardcode required usage of IEEEtran "conference" option into my class.
%# I decided against it.
%# Thus, it is required to use IARIA class like this: \documentclass[conference]{iaria}.
%# The iaria class passes all class options (like "conference") to IEEEtran.
%# The reasoning: There might be a future use case (speculatively) to pass IEEEtran options like "a4paper", for IARIA purposes (?)
%# For now, IARIA requires IEEE "conference" option, only.

% Declare that this document class file requires at least LaTeX version 2e.
\NeedsTeXFormat{LaTeX2e}

% Provide the name of your document class, the date it was last updated, and a comment about what it's used for
\ProvidesClass{iaria-lite}[2024/05/04 unofficial IARIA-lite conference template v0.3]

% Define marker counter for options (counter are global in latex):
\newcounter{iaria@pbalancetracker}
\newcounter{iaria@flushendtracker}

% Declare options:
\DeclareOption{onecolumn}{\OptionNotUsed} % IEEE option onecolumn will be ignored

\DeclareOption{pbalance}{
  \setcounter{iaria@pbalancetracker}{1}
  \typeout{iaria class: pbalance option is set.}
}
\DeclareOption{flushend}{
  \setcounter{iaria@flushendtracker}{1}
  \typeout{iaria class: flushend option is set.}
}

% We'll pass any document class options along to the underlying class
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{IEEEtran}% required IEEE options: conference (for IARIA purposes)
}

% Now we'll execute any options passed in
\ProcessOptions\relax

% Instead of defining each and every little detail required to create a new document class,
% you can base your class on an existing document class.
\LoadClass{IEEEtran}

\RequirePackage{times} % Times New Roman

\RequirePackage{graphicx}
\RequirePackage{xcolor}

\RequirePackage{url}
\RequirePackage{orcidlink}
\RequirePackage{hyperref}
\hypersetup{hidelinks,unicode}

\makeatletter
% Diferring from IEEE, IARIA requires non-abbreviated references:
\renewcommand{\fnum@figure}{Figure~\thefigure}
% Diferring from IEEE, IARIA requires 14 point bold Times New Roman for the title
\renewcommand{\title}[1]{\renewcommand{\@title}{\bfseries\Large #1}}
% Diferring from IEEE, IARIA requires "Keywords" instead of "Index Terms":
\renewcommand\IEEEkeywordsname{Keywords}
\makeatother

\RequirePackage{xpatch}
% Diferring from IEEE, IARIA requires a hyphen after "Keywords" instead of an  emdash:
\xpatchcmd\IEEEkeywords{---}{-}{}{}

% Diferring from IEEE, IARIA requires also the keywords in Italic (and Bold)(and lower case!):
\let\oldIEEEkeywords\IEEEkeywords
\def\IEEEkeywords{\oldIEEEkeywords\itshape\ignorespaces}

\makeatletter
\renewcommand{\IEEEauthorblockN}[1]{%
% copied from IEEEtran.cls:
    \relax\@IEEEauthorblockNstyle% set the default text style
    \gdef\@IEEEauthorblockXinterlinespace{0pt}% disable strut for spacer row
    % the \expandafter hides the \cr in conditional tex, see the array.sty docs
    % for details, probably not needed here as the \cr is in a macro
    % do a spacer row if needed
    \if@IEEEprevauthorblockincol\expandafter\@IEEEauthorblockNtopspaceline\fi
    \global\@IEEEprevauthorblockincoltrue% we now have a block in this column
    %restore the correct strut value
    \gdef\@IEEEauthorblockXinterlinespace{\@IEEEauthorblockNinterlinespace}%
    % input the author names
    \large
    #1%
    % end the row if the user did not already
    \crcr}
\makeatother

% IARIA subfigure captions require this:
\RequirePackage[caption=false,font=footnotesize]{subfig}

% IARIA requires to bring the table caption in the same line of "Table I"
\usepackage{etoolbox}
\makeatletter
\patchcmd{\@makecaption}
  {\\}
  {.\ }
  {}
  {}
\makeatother

% Balance/level columns at the last page / in bibliography
% DISCLAIMER: No solution is a 100%/perfect one!
% Mainstream option: pbalance (see https://ctan.org/pkg/pbalance)
% BUT: incompatible with arxiv automated process (!)
\ifnum\value{iaria@pbalancetracker}=1
  \typeout{iaria class: load pbalance package.}
  \RequirePackage{pbalance}
\fi
% Flushend => works with arxiv, but major incampatibility with lineno (and, thus, also with mindflow et al.)
\ifnum\value{iaria@flushendtracker}=1
  \typeout{iaria class: load flushend package.}
  \RequirePackage{flushend}
\fi

% Finally, we'll use \endinput to indicate that LaTeX can stop reading this file. LaTeX will ignore anything after this line.
\endinput
