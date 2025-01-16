%# Copyright (c) 2023-2025 Christoph P. Neumann

% DISCLAIMER:
% I had to decide whether to hardcode required usage of IEEEtran "conference"
% option into my class. I decided against it.
% Thus, it is required to use IARIA class like this:
% \documentclass[conference]{iaria}.
% The iaria class passes all class options (like "conference") to IEEEtran.
% The reasoning: There might be a future use case (speculatively) to pass
% IEEEtran options like "a4paper", for IARIA purposes (?)
% For now, IARIA requires IEEE "conference" option, only.

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{iaria-lite}[2025/01/16 unofficial IARIA-lite conference template v0.6]

% Define marker counter for options (counter are global in latex):
\newcounter{iaria@subfigtracker}
\newcounter{iaria@subcaptiontracker}
\newcounter{iaria@pbalancetracker}
\newcounter{iaria@flushendtracker}

% Declare options:

\DeclareOption{subfig}{
  \setcounter{iaria@subfigtracker}{1}
  \typeout{iaria class: subfig option is set (use subfloat command).}
}
\DeclareOption{subcaption}{
  \setcounter{iaria@subcaptiontracker}{1}
  \typeout{iaria class: subcaption option is set (use subfigure command).}
}

% IEEE option onecolumn will be ignored
\DeclareOption{onecolumn}{\OptionNotUsed}

\DeclareOption{pbalance}{
  \setcounter{iaria@pbalancetracker}{1}
  \typeout{iaria class: pbalance option is set.}
}
\DeclareOption{flushend}{
  \setcounter{iaria@flushendtracker}{1}
  \typeout{iaria class: flushend option is set.}
}

% We'll pass any document class options along to the underlying class
% required IEEE options: conference! For IARIA purposes.
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{IEEEtran}
}

% Now we'll execute any options passed in
\ProcessOptions\relax

% Instead of defining each and every little detail
% required to create a new document class,
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
% Diferring from IEEE, IARIA requires 14 point bold Times for the title
\renewcommand{\title}[1]{\renewcommand{\@title}{\bfseries\Large #1}}
% Diferring from IEEE, IARIA requires "Keywords" instead of "Index Terms":
\renewcommand\IEEEkeywordsname{Keywords}
\makeatother

\RequirePackage{xpatch}
% Diferring from IEEE, IARIA requires a hyphen
% after "Keywords" instead of an  emdash:
\xpatchcmd\IEEEkeywords{---}{-}{}{}

% Diferring from IEEE, IARIA requires also the keywords in Italic
% (and Bold)(and lower case!):
\let\oldIEEEkeywords\IEEEkeywords
\def\IEEEkeywords{\oldIEEEkeywords\itshape\ignorespaces}

\makeatletter
\renewcommand{\IEEEauthorblockN}[1]{%
% copied from IEEEtran.cls:
    \relax\@IEEEauthorblockNstyle% set the default text style
    \gdef\@IEEEauthorblockXinterlinespace{0pt}% disable strut for spacer row
    \if@IEEEprevauthorblockincol\expandafter\@IEEEauthorblockNtopspaceline\fi
    \global\@IEEEprevauthorblockincoltrue% we now have a block in this column
    \gdef\@IEEEauthorblockXinterlinespace{\@IEEEauthorblockNinterlinespace}%
    \large
    #1%
    \crcr}
\makeatother

% IARIA requires to bring the table caption in the same line of "Table I"
\usepackage{etoolbox}
\makeatletter
\patchcmd{\@makecaption}
  {\\}
  {.\ }
  {}
  {}
\makeatother

% using caption package does provide compatibility with babel package that intervenes in the tablename
\RequirePackage{caption}
% IARIA requires table caption to be (top-positioned) centered with upper case label and small caps 
\captionsetup[table]{name=TABLE,labelsep=period,justification=centering,textfont={footnotesize, sc},labelfont=footnotesize}
% IARIA requires figure caption to be (bottom-positioned) centered 
\captionsetup[figure]{font={footnotesize,rm},justification=centering,labelsep=period}

% IARIA subfigure captions require parentheses and footnotesize:
\ifnum\value{iaria@subfigtracker}=1
  \typeout{iaria class: load subfig package (use subfloat command).}
  \RequirePackage[caption=false,font=footnotesize]{subfig}
\fi
\ifnum\value{iaria@subcaptiontracker}=1
  \typeout{iaria class: load subcaption package (use subfigure command).}
  \RequirePackage{subcaption}
  % IARIA requires subfigure caption to number them with parentheses around latin chars (like "(a)" and "(b)")
  \captionsetup[subfigure]{labelformat=parens,font=footnotesize}
\fi

% Balance/level columns at the last page / in bibliography
% DISCLAIMER: No solution is a 100%/perfect one!
% Mainstream option: pbalance (see https://ctan.org/pkg/pbalance)
% BUT: incompatible with arxiv automated process (!)
\ifnum\value{iaria@pbalancetracker}=1
  \typeout{iaria class: load pbalance package.}
  \RequirePackage{pbalance}
\fi
% Flushend => works with arxiv, but major incampatibility with lineno
% (and, thus, also with mindflow et al.)
\ifnum\value{iaria@flushendtracker}=1
  \typeout{iaria class: load flushend package.}
  \RequirePackage{flushend}
\fi

% Finally, we'll use \endinput to indicate that LaTeX can stop
% reading this file. LaTeX will ignore anything after this line.
\endinput
