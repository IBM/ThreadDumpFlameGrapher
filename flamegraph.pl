#!/usr/bin/perl -w
# License: https://github.com/brendangregg/FlameGraph/blob/master/docs/cddl1.txt
# COMMON DEVELOPMENT AND DISTRIBUTION LICENSE Version 1.0
# 
# 1. Definitions.
# 
#     1.1. "Contributor" means each individual or entity that creates
#          or contributes to the creation of Modifications.
# 
#     1.2. "Contributor Version" means the combination of the Original
#          Software, prior Modifications used by a Contributor (if any),
#          and the Modifications made by that particular Contributor.
# 
#     1.3. "Covered Software" means (a) the Original Software, or (b)
#          Modifications, or (c) the combination of files containing
#          Original Software with files containing Modifications, in
#          each case including portions thereof.
# 
#     1.4. "Executable" means the Covered Software in any form other
#          than Source Code.
# 
#     1.5. "Initial Developer" means the individual or entity that first
#          makes Original Software available under this License.
# 
#     1.6. "Larger Work" means a work which combines Covered Software or
#          portions thereof with code not governed by the terms of this
#          License.
# 
#     1.7. "License" means this document.
# 
#     1.8. "Licensable" means having the right to grant, to the maximum
#          extent possible, whether at the time of the initial grant or
#          subsequently acquired, any and all of the rights conveyed
#          herein.
# 
#     1.9. "Modifications" means the Source Code and Executable form of
#          any of the following:
# 
#         A. Any file that results from an addition to, deletion from or
#            modification of the contents of a file containing Original
#            Software or previous Modifications;
# 
#         B. Any new file that contains any part of the Original
#            Software or previous Modifications; or
# 
#         C. Any new file that is contributed or otherwise made
#            available under the terms of this License.
# 
#     1.10. "Original Software" means the Source Code and Executable
#           form of computer software code that is originally released
#           under this License.
# 
#     1.11. "Patent Claims" means any patent claim(s), now owned or
#           hereafter acquired, including without limitation, method,
#           process, and apparatus claims, in any patent Licensable by
#           grantor.
# 
#     1.12. "Source Code" means (a) the common form of computer software
#           code in which modifications are made and (b) associated
#           documentation included in or with such code.
# 
#     1.13. "You" (or "Your") means an individual or a legal entity
#           exercising rights under, and complying with all of the terms
#           of, this License.  For legal entities, "You" includes any
#           entity which controls, is controlled by, or is under common
#           control with You.  For purposes of this definition,
#           "control" means (a) the power, direct or indirect, to cause
#           the direction or management of such entity, whether by
#           contract or otherwise, or (b) ownership of more than fifty
#           percent (50%) of the outstanding shares or beneficial
#           ownership of such entity.
# 
# 2. License Grants.
# 
#     2.1. The Initial Developer Grant.
# 
#     Conditioned upon Your compliance with Section 3.1 below and
#     subject to third party intellectual property claims, the Initial
#     Developer hereby grants You a world-wide, royalty-free,
#     non-exclusive license:
# 
#         (a) under intellectual property rights (other than patent or
#             trademark) Licensable by Initial Developer, to use,
#             reproduce, modify, display, perform, sublicense and
#             distribute the Original Software (or portions thereof),
#             with or without Modifications, and/or as part of a Larger
#             Work; and
# 
#         (b) under Patent Claims infringed by the making, using or
#             selling of Original Software, to make, have made, use,
#             practice, sell, and offer for sale, and/or otherwise
#             dispose of the Original Software (or portions thereof).
# 
#         (c) The licenses granted in Sections 2.1(a) and (b) are
#             effective on the date Initial Developer first distributes
#             or otherwise makes the Original Software available to a
#             third party under the terms of this License.
# 
#         (d) Notwithstanding Section 2.1(b) above, no patent license is
#             granted: (1) for code that You delete from the Original
#             Software, or (2) for infringements caused by: (i) the
#             modification of the Original Software, or (ii) the
#             combination of the Original Software with other software
#             or devices.
# 
#     2.2. Contributor Grant.
# 
#     Conditioned upon Your compliance with Section 3.1 below and
#     subject to third party intellectual property claims, each
#     Contributor hereby grants You a world-wide, royalty-free,
#     non-exclusive license:
# 
#         (a) under intellectual property rights (other than patent or
#             trademark) Licensable by Contributor to use, reproduce,
#             modify, display, perform, sublicense and distribute the
#             Modifications created by such Contributor (or portions
#             thereof), either on an unmodified basis, with other
#             Modifications, as Covered Software and/or as part of a
#             Larger Work; and
# 
#         (b) under Patent Claims infringed by the making, using, or
#             selling of Modifications made by that Contributor either
#             alone and/or in combination with its Contributor Version
#             (or portions of such combination), to make, use, sell,
#             offer for sale, have made, and/or otherwise dispose of:
#             (1) Modifications made by that Contributor (or portions
#             thereof); and (2) the combination of Modifications made by
#             that Contributor with its Contributor Version (or portions
#             of such combination).
# 
#         (c) The licenses granted in Sections 2.2(a) and 2.2(b) are
#             effective on the date Contributor first distributes or
#             otherwise makes the Modifications available to a third
#             party.
# 
#         (d) Notwithstanding Section 2.2(b) above, no patent license is
#             granted: (1) for any code that Contributor has deleted
#             from the Contributor Version; (2) for infringements caused
#             by: (i) third party modifications of Contributor Version,
#             or (ii) the combination of Modifications made by that
#             Contributor with other software (except as part of the
#             Contributor Version) or other devices; or (3) under Patent
#             Claims infringed by Covered Software in the absence of
#             Modifications made by that Contributor.
# 
# 3. Distribution Obligations.
# 
#     3.1. Availability of Source Code.
# 
#     Any Covered Software that You distribute or otherwise make
#     available in Executable form must also be made available in Source
#     Code form and that Source Code form must be distributed only under
#     the terms of this License.  You must include a copy of this
#     License with every copy of the Source Code form of the Covered
#     Software You distribute or otherwise make available.  You must
#     inform recipients of any such Covered Software in Executable form
#     as to how they can obtain such Covered Software in Source Code
#     form in a reasonable manner on or through a medium customarily
#     used for software exchange.
# 
#     3.2. Modifications.
# 
#     The Modifications that You create or to which You contribute are
#     governed by the terms of this License.  You represent that You
#     believe Your Modifications are Your original creation(s) and/or
#     You have sufficient rights to grant the rights conveyed by this
#     License.
# 
#     3.3. Required Notices.
# 
#     You must include a notice in each of Your Modifications that
#     identifies You as the Contributor of the Modification.  You may
#     not remove or alter any copyright, patent or trademark notices
#     contained within the Covered Software, or any notices of licensing
#     or any descriptive text giving attribution to any Contributor or
#     the Initial Developer.
# 
#     3.4. Application of Additional Terms.
# 
#     You may not offer or impose any terms on any Covered Software in
#     Source Code form that alters or restricts the applicable version
#     of this License or the recipients' rights hereunder.  You may
#     choose to offer, and to charge a fee for, warranty, support,
#     indemnity or liability obligations to one or more recipients of
#     Covered Software.  However, you may do so only on Your own behalf,
#     and not on behalf of the Initial Developer or any Contributor.
#     You must make it absolutely clear that any such warranty, support,
#     indemnity or liability obligation is offered by You alone, and You
#     hereby agree to indemnify the Initial Developer and every
#     Contributor for any liability incurred by the Initial Developer or
#     such Contributor as a result of warranty, support, indemnity or
#     liability terms You offer.
# 
#     3.5. Distribution of Executable Versions.
# 
#     You may distribute the Executable form of the Covered Software
#     under the terms of this License or under the terms of a license of
#     Your choice, which may contain terms different from this License,
#     provided that You are in compliance with the terms of this License
#     and that the license for the Executable form does not attempt to
#     limit or alter the recipient's rights in the Source Code form from
#     the rights set forth in this License.  If You distribute the
#     Covered Software in Executable form under a different license, You
#     must make it absolutely clear that any terms which differ from
#     this License are offered by You alone, not by the Initial
#     Developer or Contributor.  You hereby agree to indemnify the
#     Initial Developer and every Contributor for any liability incurred
#     by the Initial Developer or such Contributor as a result of any
#     such terms You offer.
# 
#     3.6. Larger Works.
# 
#     You may create a Larger Work by combining Covered Software with
#     other code not governed by the terms of this License and
#     distribute the Larger Work as a single product.  In such a case,
#     You must make sure the requirements of this License are fulfilled
#     for the Covered Software.
# 
# 4. Versions of the License.
# 
#     4.1. New Versions.
# 
#     Sun Microsystems, Inc. is the initial license steward and may
#     publish revised and/or new versions of this License from time to
#     time.  Each version will be given a distinguishing version number.
#     Except as provided in Section 4.3, no one other than the license
#     steward has the right to modify this License.
# 
#     4.2. Effect of New Versions.
# 
#     You may always continue to use, distribute or otherwise make the
#     Covered Software available under the terms of the version of the
#     License under which You originally received the Covered Software.
#     If the Initial Developer includes a notice in the Original
#     Software prohibiting it from being distributed or otherwise made
#     available under any subsequent version of the License, You must
#     distribute and make the Covered Software available under the terms
#     of the version of the License under which You originally received
#     the Covered Software.  Otherwise, You may also choose to use,
#     distribute or otherwise make the Covered Software available under
#     the terms of any subsequent version of the License published by
#     the license steward.
# 
#     4.3. Modified Versions.
# 
#     When You are an Initial Developer and You want to create a new
#     license for Your Original Software, You may create and use a
#     modified version of this License if You: (a) rename the license
#     and remove any references to the name of the license steward
#     (except to note that the license differs from this License); and
#     (b) otherwise make it clear that the license contains terms which
#     differ from this License.
# 
# 5. DISCLAIMER OF WARRANTY.
# 
#     COVERED SOFTWARE IS PROVIDED UNDER THIS LICENSE ON AN "AS IS"
#     BASIS, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
#     INCLUDING, WITHOUT LIMITATION, WARRANTIES THAT THE COVERED
#     SOFTWARE IS FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR
#     PURPOSE OR NON-INFRINGING.  THE ENTIRE RISK AS TO THE QUALITY AND
#     PERFORMANCE OF THE COVERED SOFTWARE IS WITH YOU.  SHOULD ANY
#     COVERED SOFTWARE PROVE DEFECTIVE IN ANY RESPECT, YOU (NOT THE
#     INITIAL DEVELOPER OR ANY OTHER CONTRIBUTOR) ASSUME THE COST OF ANY
#     NECESSARY SERVICING, REPAIR OR CORRECTION.  THIS DISCLAIMER OF
#     WARRANTY CONSTITUTES AN ESSENTIAL PART OF THIS LICENSE.  NO USE OF
#     ANY COVERED SOFTWARE IS AUTHORIZED HEREUNDER EXCEPT UNDER THIS
#     DISCLAIMER.
# 
# 6. TERMINATION.
# 
#     6.1. This License and the rights granted hereunder will terminate
#     automatically if You fail to comply with terms herein and fail to
#     cure such breach within 30 days of becoming aware of the breach.
#     Provisions which, by their nature, must remain in effect beyond
#     the termination of this License shall survive.
# 
#     6.2. If You assert a patent infringement claim (excluding
#     declaratory judgment actions) against Initial Developer or a
#     Contributor (the Initial Developer or Contributor against whom You
#     assert such claim is referred to as "Participant") alleging that
#     the Participant Software (meaning the Contributor Version where
#     the Participant is a Contributor or the Original Software where
#     the Participant is the Initial Developer) directly or indirectly
#     infringes any patent, then any and all rights granted directly or
#     indirectly to You by such Participant, the Initial Developer (if
#     the Initial Developer is not the Participant) and all Contributors
#     under Sections 2.1 and/or 2.2 of this License shall, upon 60 days
#     notice from Participant terminate prospectively and automatically
#     at the expiration of such 60 day notice period, unless if within
#     such 60 day period You withdraw Your claim with respect to the
#     Participant Software against such Participant either unilaterally
#     or pursuant to a written agreement with Participant.
# 
#     6.3. In the event of termination under Sections 6.1 or 6.2 above,
#     all end user licenses that have been validly granted by You or any
#     distributor hereunder prior to termination (excluding licenses
#     granted to You by any distributor) shall survive termination.
# 
# 7. LIMITATION OF LIABILITY.
# 
#     UNDER NO CIRCUMSTANCES AND UNDER NO LEGAL THEORY, WHETHER TORT
#     (INCLUDING NEGLIGENCE), CONTRACT, OR OTHERWISE, SHALL YOU, THE
#     INITIAL DEVELOPER, ANY OTHER CONTRIBUTOR, OR ANY DISTRIBUTOR OF
#     COVERED SOFTWARE, OR ANY SUPPLIER OF ANY OF SUCH PARTIES, BE
#     LIABLE TO ANY PERSON FOR ANY INDIRECT, SPECIAL, INCIDENTAL, OR
#     CONSEQUENTIAL DAMAGES OF ANY CHARACTER INCLUDING, WITHOUT
#     LIMITATION, DAMAGES FOR LOST PROFITS, LOSS OF GOODWILL, WORK
#     STOPPAGE, COMPUTER FAILURE OR MALFUNCTION, OR ANY AND ALL OTHER
#     COMMERCIAL DAMAGES OR LOSSES, EVEN IF SUCH PARTY SHALL HAVE BEEN
#     INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  THIS LIMITATION OF
#     LIABILITY SHALL NOT APPLY TO LIABILITY FOR DEATH OR PERSONAL
#     INJURY RESULTING FROM SUCH PARTY'S NEGLIGENCE TO THE EXTENT
#     APPLICABLE LAW PROHIBITS SUCH LIMITATION.  SOME JURISDICTIONS DO
#     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR
#     CONSEQUENTIAL DAMAGES, SO THIS EXCLUSION AND LIMITATION MAY NOT
#     APPLY TO YOU.
# 
# 8. U.S. GOVERNMENT END USERS.
# 
#     The Covered Software is a "commercial item," as that term is
#     defined in 48 C.F.R. 2.101 (Oct. 1995), consisting of "commercial
#     computer software" (as that term is defined at 48
#     C.F.R. 252.227-7014(a)(1)) and "commercial computer software
#     documentation" as such terms are used in 48 C.F.R. 12.212
#     (Sept. 1995).  Consistent with 48 C.F.R. 12.212 and 48
#     C.F.R. 227.7202-1 through 227.7202-4 (June 1995), all
#     U.S. Government End Users acquire Covered Software with only those
#     rights set forth herein.  This U.S. Government Rights clause is in
#     lieu of, and supersedes, any other FAR, DFAR, or other clause or
#     provision that addresses Government rights in computer software
#     under this License.
# 
# 9. MISCELLANEOUS.
# 
#     This License represents the complete agreement concerning subject
#     matter hereof.  If any provision of this License is held to be
#     unenforceable, such provision shall be reformed only to the extent
#     necessary to make it enforceable.  This License shall be governed
#     by the law of the jurisdiction specified in a notice contained
#     within the Original Software (except to the extent applicable law,
#     if any, provides otherwise), excluding such jurisdiction's
#     conflict-of-law provisions.  Any litigation relating to this
#     License shall be subject to the jurisdiction of the courts located
#     in the jurisdiction and venue specified in a notice contained
#     within the Original Software, with the losing party responsible
#     for costs, including, without limitation, court costs and
#     reasonable attorneys' fees and expenses.  The application of the
#     United Nations Convention on Contracts for the International Sale
#     of Goods is expressly excluded.  Any law or regulation which
#     provides that the language of a contract shall be construed
#     against the drafter shall not apply to this License.  You agree
#     that You alone are responsible for compliance with the United
#     States export administration regulations (and the export control
#     laws and regulation of any other countries) when You use,
#     distribute or otherwise make available any Covered Software.
# 
# 10. RESPONSIBILITY FOR CLAIMS.
# 
#     As between Initial Developer and the Contributors, each party is
#     responsible for claims and damages arising, directly or
#     indirectly, out of its utilization of rights under this License
#     and You agree to work with Initial Developer and Contributors to
#     distribute such responsibility on an equitable basis.  Nothing
#     herein is intended or shall be deemed to constitute any admission
#     of liability.
# 
# --------------------------------------------------------------------
# 
# NOTICE PURSUANT TO SECTION 9 OF THE COMMON DEVELOPMENT AND
# DISTRIBUTION LICENSE (CDDL)
# 
# For Covered Software in this distribution, this License shall
# be governed by the laws of the State of California (excluding
# conflict-of-law provisions).
# 
# Any litigation relating to this License shall be subject to the
# jurisdiction of the Federal Courts of the Northern District of
# California and the state courts of the State of California, with
# venue lying in Santa Clara County, California.
# 
#
# flamegraph.pl		flame stack grapher.
#
# This takes stack samples and renders a call graph, allowing hot functions
# and codepaths to be quickly identified.  Stack samples can be generated using
# tools such as DTrace, perf, SystemTap, and Instruments.
#
# USAGE: ./flamegraph.pl [options] input.txt > graph.svg
#
#        grep funcA input.txt | ./flamegraph.pl [options] > graph.svg
#
# Then open the resulting .svg in a web browser, for interactivity: mouse-over
# frames for info, click to zoom, and ctrl-F to search.
#
# Options are listed in the usage message (--help).
#
# The input is stack frames and sample counts formatted as single lines.  Each
# frame in the stack is semicolon separated, with a space and count at the end
# of the line.  These can be generated for Linux perf script output using
# stackcollapse-perf.pl, for DTrace using stackcollapse.pl, and for other tools
# using the other stackcollapse programs.  Example input:
#
#  swapper;start_kernel;rest_init;cpu_idle;default_idle;native_safe_halt 1
#
# An optional extra column of counts can be provided to generate a differential
# flame graph of the counts, colored red for more, and blue for less.  This
# can be useful when using flame graphs for non-regression testing.
# See the header comment in the difffolded.pl program for instructions.
#
# The input functions can optionally have annotations at the end of each
# function name, following a precedent by some tools (Linux perf's _[k]):
# 	_[k] for kernel
#	_[i] for inlined
#	_[j] for jit
#	_[w] for waker
# Some of the stackcollapse programs support adding these annotations, eg,
# stackcollapse-perf.pl --kernel --jit. They are used merely for colors by
# some palettes, eg, flamegraph.pl --color=java.
#
# The output flame graph shows relative presence of functions in stack samples.
# The ordering on the x-axis has no meaning; since the data is samples, time
# order of events is not known.  The order used sorts function names
# alphabetically.
#
# While intended to process stack samples, this can also process stack traces.
# For example, tracing stacks for memory allocation, or resource usage.  You
# can use --title to set the title to reflect the content, and --countname
# to change "samples" to "bytes" etc.
#
# There are a few different palettes, selectable using --color.  By default,
# the colors are selected at random (except for differentials).  Functions
# called "-" will be printed gray, which can be used for stack separators (eg,
# between user and kernel stacks).
#
# HISTORY
#
# This was inspired by Neelakanth Nadgir's excellent function_call_graph.rb
# program, which visualized function entry and return trace events.  As Neel
# wrote: "The output displayed is inspired by Roch's CallStackAnalyzer which
# was in turn inspired by the work on vftrace by Jan Boerhout".  See:
# https://blogs.oracle.com/realneel/entry/visualizing_callstacks_via_dtrace_and
#
# Copyright 2024 IBM Corporation. All Rights Reserved.
# Copyright 2016 Netflix, Inc.
# Copyright 2011 Joyent, Inc.  All rights reserved.
# Copyright 2011 Brendan Gregg.  All rights reserved.
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at docs/cddl1.txt or
# http://opensource.org/licenses/CDDL-1.0.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at docs/cddl1.txt.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#-------------------------------------------------------------------
# 
# REVISION HISTORY
#
# 02-May-2024   Kevin Grigorenko (IBM)   
#    Added right click handler which pops up additional information. 
#    Changed some of the coloring.
#
# 11-Oct-2014	Adrien Mahieux	   
#    Added zoom.
#
# 21-Nov-2013   Shawn Sterling     
#    Added consistent palette file option
#
# 17-Mar-2013   Tim Bunce          
#    Added options and more tunables.
#
# 15-Dec-2011	Dave Pacheco	   
#    Support for frames with whitespace.
#
# 10-Sep-2011	Brendan Gregg	   
#    Created this.

use strict;

use Getopt::Long;

use open qw(:std :utf8);

# tunables
my $encoding;
my $fonttype = "Verdana";
my $imagewidth = 1200;          # max width, pixels
my $frameheight = 16;           # max height is dynamic
my $fontsize = 12;              # base text size
my $fontwidth = 0.59;           # avg width relative to fontsize
my $minwidth = 0.1;             # min function width, pixels or percentage of time
my $nametype = "Function:";     # what are the names in the data?
my $countname = "samples";      # what are the counts in the data?
my $colors = "hot";             # color theme
my $bgcolors = "";              # background color theme
my $nameattrfile;               # file holding function attributes
my $timemax;                    # (override the) sum of the counts
my $factor = 1;                 # factor to scale counts by
my $hash = 0;                   # color by function name
my $rand = 0;                   # color randomly
my $palette = 0;                # if we use consistent palettes (default off)
my %palette_map;                # palette map hash
my $pal_file = "palette.map";   # palette map file name
my $stackreverse = 0;           # reverse stack order, switching merge end
my $inverted = 0;               # icicle graph
my $flamechart = 0;             # produce a flame chart (sort by time, do not merge stacks)
my $negate = 0;                 # switch differential hues
my $titletext = "";             # centered heading
my $titledefault = "Flame Graph";	# overwritten by --title
my $titleinverted = "Icicle Graph";	#   "    "
my $searchcolor = "rgb(230,0,230)";	# color for search highlighting
my $notestext = "";		# embedded notes in SVG
my $subtitletext = "";		# second level title (optional)
my $help = 0;

sub usage {
	die <<USAGE_END;
USAGE: $0 [options] infile > outfile.svg\n
	--title TEXT     # change title text
	--subtitle TEXT  # second level title (optional)
	--width NUM      # width of image (default 1200)
	--height NUM     # height of each frame (default 16)
	--minwidth NUM   # omit smaller functions. In pixels or use "%" for
	                 # percentage of time (default 0.1 pixels)
	--fonttype FONT  # font type (default "Verdana")
	--fontsize NUM   # font size (default 12)
	--countname TEXT # count type label (default "samples")
	--nametype TEXT  # name type label (default "Function:")
	--colors PALETTE # set color palette. choices are: hot (default), mem,
	                 # io, wakeup, chain, java, js, perl, red, green, blue,
	                 # aqua, yellow, purple, orange
	--bgcolors COLOR # set background colors. gradient choices are yellow
	                 # (default), blue, green, grey; flat colors use "#rrggbb"
	--hash           # colors are keyed by function name hash
	--random         # colors are randomly generated
	--cp             # use consistent palette (palette.map)
	--reverse        # generate stack-reversed flame graph
	--inverted       # icicle graph
	--flamechart     # produce a flame chart (sort by time, do not merge stacks)
	--negate         # switch differential hues (blue<->red)
	--notes TEXT     # add notes comment in SVG (for debugging)
	--help           # this message

	eg,
	$0 --title="Flame Graph: malloc()" trace.txt > graph.svg
USAGE_END
}

GetOptions(
	'fonttype=s'  => \$fonttype,
	'width=i'     => \$imagewidth,
	'height=i'    => \$frameheight,
	'encoding=s'  => \$encoding,
	'fontsize=f'  => \$fontsize,
	'fontwidth=f' => \$fontwidth,
	'minwidth=s'  => \$minwidth,
	'title=s'     => \$titletext,
	'subtitle=s'  => \$subtitletext,
	'nametype=s'  => \$nametype,
	'countname=s' => \$countname,
	'nameattr=s'  => \$nameattrfile,
	'total=s'     => \$timemax,
	'factor=f'    => \$factor,
	'colors=s'    => \$colors,
	'bgcolors=s'  => \$bgcolors,
	'hash'        => \$hash,
	'random'      => \$rand,
	'cp'          => \$palette,
	'reverse'     => \$stackreverse,
	'inverted'    => \$inverted,
	'flamechart'  => \$flamechart,
	'negate'      => \$negate,
	'notes=s'     => \$notestext,
	'help'        => \$help,
) or usage();
$help && usage();

# internals
my $ypad1 = $fontsize * 3;      # pad top, include title
my $ypad2 = $fontsize * 2 + 10; # pad bottom, include labels
my $ypad3 = $fontsize * 2;      # pad top, include subtitle (optional)
my $xpad = 10;                  # pad lefm and right
my $framepad = 1;		# vertical padding for frames
my $depthmax = 0;
my %Events;
my %nameattr;

if ($flamechart && $titletext eq "") {
	$titletext = "Flame Chart";
}

if ($titletext eq "") {
	unless ($inverted) {
		$titletext = $titledefault;
	} else {
		$titletext = $titleinverted;
	}
}

if ($nameattrfile) {
	# The name-attribute file format is a function name followed by a tab then
	# a sequence of tab separated name=value pairs.
	open my $attrfh, $nameattrfile or die "Can't read $nameattrfile: $!\n";
	while (<$attrfh>) {
		chomp;
		my ($funcname, $attrstr) = split /\t/, $_, 2;
		die "Invalid format in $nameattrfile" unless defined $attrstr;
		$nameattr{$funcname} = { map { split /=/, $_, 2 } split /\t/, $attrstr };
	}
}

if ($notestext =~ /[<>]/) {
	die "Notes string can't contain < or >"
}

# Ensure minwidth is a valid floating-point number,
# print usage string if not
my $minwidth_f;
if ($minwidth =~ /^([0-9.]+)%?$/) {
	$minwidth_f = $1;
} else {
	warn "Value '$minwidth' is invalid for minwidth, expected a float.\n";
	usage();
}

# background colors:
# - yellow gradient: default (hot, java, js, perl)
# - green gradient: mem
# - blue gradient: io, wakeup, chain
# - gray gradient: flat colors (red, green, blue, ...)
if ($bgcolors eq "") {
	# choose a default
	if ($colors eq "mem") {
		$bgcolors = "green";
	} elsif ($colors =~ /^(io|wakeup|chain)$/) {
		$bgcolors = "blue";
	} elsif ($colors =~ /^(red|green|blue|aqua|yellow|purple|orange)$/) {
		$bgcolors = "grey";
	} else {
		$bgcolors = "yellow";
	}
}
my ($bgcolor1, $bgcolor2);
if ($bgcolors eq "yellow") {
	$bgcolor1 = "#eeeeee";       # background color gradient start
	$bgcolor2 = "#eeeeb0";       # background color gradient stop
} elsif ($bgcolors eq "blue") {
	$bgcolor1 = "#eeeeee"; $bgcolor2 = "#e0e0ff";
} elsif ($bgcolors eq "green") {
	$bgcolor1 = "#eef2ee"; $bgcolor2 = "#e0ffe0";
} elsif ($bgcolors eq "grey") {
	$bgcolor1 = "#f8f8f8"; $bgcolor2 = "#e8e8e8";
} elsif ($bgcolors =~ /^#......$/) {
	$bgcolor1 = $bgcolor2 = $bgcolors;
} else {
	die "Unrecognized bgcolor option \"$bgcolors\""
}

# SVG functions
{ package SVG;
	sub new {
		my $class = shift;
		my $self = {};
		bless ($self, $class);
		return $self;
	}

	sub header {
		my ($self, $w, $h) = @_;
		my $enc_attr = '';
		if (defined $encoding) {
			$enc_attr = qq{ encoding="$encoding"};
		}
		$self->{svg} .= <<SVG;
<?xml version="1.0"$enc_attr standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" width="$w" height="$h" onload="init(evt)" viewBox="0 0 $w $h" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<!-- Flame graph stack visualization. See https://github.com/brendangregg/FlameGraph for latest version, and http://www.brendangregg.com/flamegraphs.html for examples. -->
<!-- NOTES: $notestext -->
SVG
	}

	sub include {
		my ($self, $content) = @_;
		$self->{svg} .= $content;
	}

	sub colorAllocate {
		my ($self, $r, $g, $b) = @_;
		return "rgb($r,$g,$b)";
	}

	sub group_start {
		my ($self, $attr) = @_;

		my @g_attr = map {
			exists $attr->{$_} ? sprintf(qq/$_="%s"/, $attr->{$_}) : ()
		} qw(id class);
		push @g_attr, $attr->{g_extra} if $attr->{g_extra};
		if ($attr->{href}) {
			my @a_attr;
			push @a_attr, sprintf qq/xlink:href="%s"/, $attr->{href} if $attr->{href};
			# default target=_top else links will open within SVG <object>
			push @a_attr, sprintf qq/target="%s"/, $attr->{target} || "_top";
			push @a_attr, $attr->{a_extra}                           if $attr->{a_extra};
			$self->{svg} .= sprintf qq/<a %s>\n/, join(' ', (@a_attr, @g_attr));
		} else {
			$self->{svg} .= sprintf qq/<g %s>\n/, join(' ', @g_attr);
		}

		$self->{svg} .= sprintf qq/<title>%s<\/title>/, $attr->{title}
			if $attr->{title}; # should be first element within g container
	}

	sub group_end {
		my ($self, $attr) = @_;
		$self->{svg} .= $attr->{href} ? qq/<\/a>\n/ : qq/<\/g>\n/;
	}

	sub filledRectangle {
		my ($self, $x1, $y1, $x2, $y2, $fill, $extra) = @_;
		$x1 = sprintf "%0.1f", $x1;
		$x2 = sprintf "%0.1f", $x2;
		my $w = sprintf "%0.1f", $x2 - $x1;
		my $h = sprintf "%0.1f", $y2 - $y1;
		$extra = defined $extra ? $extra : "";
		$self->{svg} .= qq/<rect x="$x1" y="$y1" width="$w" height="$h" fill="$fill" $extra \/>\n/;
	}

	sub stringTTF {
		my ($self, $id, $x, $y, $str, $extra) = @_;
		$x = sprintf "%0.2f", $x;
		$id =  defined $id ? qq/id="$id"/ : "";
		$extra ||= "";
		$self->{svg} .= qq/<text $id x="$x" y="$y" $extra>$str<\/text>\n/;
	}

	sub svg {
		my $self = shift;
		return "$self->{svg}</svg>\n";
	}
	1;
}

sub namehash {
	# Generate a vector hash for the name string, weighting early over
	# later characters. We want to pick the same colors for function
	# names across different flame graphs.
	my $name = shift;
	my $vector = 0;
	my $weight = 1;
	my $max = 1;
	my $mod = 10;
	# if module name present, trunc to 1st char
	$name =~ s/.(.*?)`//;
	foreach my $c (split //, $name) {
		my $i = (ord $c) % $mod;
		$vector += ($i / ($mod++ - 1)) * $weight;
		$max += 1 * $weight;
		$weight *= 0.70;
		last if $mod > 12;
	}
	return (1 - $vector / $max)
}

sub sum_namehash {
  my $name = shift;
  return unpack("%32W*", $name);
}

sub random_namehash {
	# Generate a random hash for the name string.
	# This ensures that functions with the same name have the same color,
	# both within a flamegraph and across multiple flamegraphs without
	# needing to set a palette and while preserving the original flamegraph
	# optic, unlike what happens with --hash.
	my $name = shift;
	my $hash = sum_namehash($name);
	srand($hash);
	return rand(1)
}

sub color {
	my ($type, $hash, $name, $width) = @_;
	my ($v1, $v2, $v3);

	if ($hash) {
		$v1 = namehash($name);
		$v2 = $v3 = namehash(scalar reverse $name);
	} elsif ($rand) {
		$v1 = rand(1);
		$v2 = rand(1);
		$v3 = rand(1);
	} else {
		$v1 = random_namehash($name);
		$v2 = random_namehash($name);
		$v3 = random_namehash($name);
	}

	# theme palettes
	if (defined $type and $type eq "hot") {
		my $r = 205 + int(50 * $v3);
		my $g = 0 + int(230 * $v1);
		my $b = 0 + int(55 * $v2);
		return "rgb($r,$g,$b)";
	}
	if (defined $type and $type eq "mem") {
		my $r = 0;
		my $g = 190 + int(50 * $v2);
		my $b = 0 + int(210 * $v1);
		return "rgb($r,$g,$b)";
	}
	if (defined $type and $type eq "io") {
		my $r = 80 + int(60 * $v1);
		my $g = $r;
		my $b = 190 + int(55 * $v2);
		return "rgb($r,$g,$b)";
	}

	# multi palettes
	if (defined $type and $type eq "java") {
		# Handle both annotations (_[j], _[i], ...; which are
		# accurate), as well as input that lacks any annotations, as
		# best as possible. Without annotations, we get a little hacky
		# and match on java|org|com, etc.
		if ($name =~ m:_\[j\]$:) {	# jit annotation
			$type = "green";
		} elsif ($name =~ m:_\[i\]$:) {	# inline annotation
			$type = "aqua";
		} elsif ($name =~ m:^L?(java|javax|jdk|net|org|com|io|sun)/:) {	# Java
			$type = "green";
		} elsif ($name =~ /:::/) {      # Java, typical perf-map-agent method separator
			$type = "green";
		} elsif ($name =~ /::/) {	# C++
			$type = "yellow";
		} elsif ($name =~ m:_\[k\]$:) {	# kernel annotation
			$type = "orange";
		} elsif ($name =~ /::/) {	# C++
			$type = "yellow";
		} else {			# system
			$type = "red";
		}
		# fall-through to color palettes
	}
	if (defined $type and $type eq "perl") {
		if ($name =~ /::/) {		# C++
			$type = "yellow";
		} elsif ($name =~ m:Perl: or $name =~ m:\.pl:) {	# Perl
			$type = "green";
		} elsif ($name =~ m:_\[k\]$:) {	# kernel
			$type = "orange";
		} else {			# system
			$type = "red";
		}
		# fall-through to color palettes
	}
	if (defined $type and $type eq "js") {
		# Handle both annotations (_[j], _[i], ...; which are
		# accurate), as well as input that lacks any annotations, as
		# best as possible. Without annotations, we get a little hacky,
		# and match on a "/" with a ".js", etc.
		if ($name =~ m:_\[j\]$:) {	# jit annotation
			if ($name =~ m:/:) {
				$type = "green";	# source
			} else {
				$type = "aqua";		# builtin
			}
		} elsif ($name =~ /::/) {	# C++
			$type = "yellow";
		} elsif ($name =~ m:/.*\.js:) {	# JavaScript (match "/" in path)
			$type = "green";
		} elsif ($name =~ m/:/) {	# JavaScript (match ":" in builtin)
			$type = "aqua";
		} elsif ($name =~ m/^ $/) {	# Missing symbol
			$type = "green";
		} elsif ($name =~ m:_\[k\]:) {	# kernel
			$type = "orange";
		} else {			# system
			$type = "red";
		}
		# fall-through to color palettes
	}
	if (defined $type and $type eq "wakeup") {
		$type = "aqua";
		# fall-through to color palettes
	}
	if (defined $type and $type eq "chain") {
		if ($name =~ m:_\[w\]:) {	# waker
			$type = "aqua"
		} else {			# off-CPU
			$type = "blue";
		}
		# fall-through to color palettes
	}

	# color palettes
	if (defined $type and $type eq "red") {
		#my $r = 200 + int(55 * $v1);
		#my $x = 50 + int(80 * $v1);
		my $r = 255;
		my $g = 0;
		my $proportion = ($width / $imagewidth);
		if ($proportion > 0.2) {
			$g = int(75 * (1 - $proportion));
		} elsif ($proportion > 0.1) {
			$g = 75 + int(25 * (1 - $proportion));
		} elsif ($proportion > 0.05) {
			$g = 100 + int(50 * (1 - ($proportion * 10)));
		} else {
			$g = 150 + int(50 * (1 - ($proportion * 10)));
		}
		return "rgb($r,$g,0)";
	}
	if (defined $type and $type eq "green") {
		my $g = 200 + int(55 * $v1);
		my $x = 50 + int(60 * $v1);
		return "rgb($x,$g,$x)";
	}
	if (defined $type and $type eq "blue") {
		my $b = 205 + int(50 * $v1);
		my $x = 80 + int(60 * $v1);
		return "rgb($x,$x,$b)";
	}
	if (defined $type and $type eq "yellow") {
		my $x = 175 + int(55 * $v1);
		my $b = 50 + int(20 * $v1);
		return "rgb($x,$x,$b)";
	}
	if (defined $type and $type eq "purple") {
		my $x = 190 + int(65 * $v1);
		my $g = 80 + int(60 * $v1);
		return "rgb($x,$g,$x)";
	}
	if (defined $type and $type eq "aqua") {
		my $r = 50 + int(60 * $v1);
		my $g = 165 + int(55 * $v1);
		my $b = 165 + int(55 * $v1);
		return "rgb($r,$g,$b)";
	}
	if (defined $type and $type eq "orange") {
		my $r = 190 + int(65 * $v1);
		my $g = 90 + int(65 * $v1);
		return "rgb($r,$g,0)";
	}

	return "rgb(0,0,0)";
}

sub color_scale {
	my ($value, $max) = @_;
	my ($r, $g, $b) = (255, 255, 255);
	$value = -$value if $negate;
	if ($value > 0) {
		$g = $b = int(210 * ($max - $value) / $max);
	} elsif ($value < 0) {
		$r = $g = int(210 * ($max + $value) / $max);
	}
	return "rgb($r,$g,$b)";
}

sub color_map {
	my ($colors, $func, $width) = @_;
	if (exists $palette_map{$func}) {
		return $palette_map{$func};
	} else {
		$palette_map{$func} = color($colors, $hash, $func, $width);
		return $palette_map{$func};
	}
}

sub write_palette {
	open(FILE, ">$pal_file");
	foreach my $key (sort keys %palette_map) {
		print FILE $key."->".$palette_map{$key}."\n";
	}
	close(FILE);
}

sub read_palette {
	if (-e $pal_file) {
	open(FILE, $pal_file) or die "can't open file $pal_file: $!";
	while ( my $line = <FILE>) {
		chomp($line);
		(my $key, my $value) = split("->",$line);
		$palette_map{$key}=$value;
	}
	close(FILE)
	}
}

my %Node;	# Hash of merged frame data
my %Tmp;

# flow() merges two stacks, storing the merged frames and value data in %Node.
sub flow {
	my ($last, $this, $v, $d) = @_;

	my $len_a = @$last - 1;
	my $len_b = @$this - 1;

	my $i = 0;
	my $len_same;
	for (; $i <= $len_a; $i++) {
		last if $i > $len_b;
		last if $last->[$i] ne $this->[$i];
	}
	$len_same = $i;

	for ($i = $len_a; $i >= $len_same; $i--) {
		my $k = "$last->[$i];$i";
		# a unique ID is constructed from "func;depth;etime";
		# func-depth isn't unique, it may be repeated later.
		$Node{"$k;$v"}->{stime} = delete $Tmp{$k}->{stime};
		if (defined $Tmp{$k}->{delta}) {
			$Node{"$k;$v"}->{delta} = delete $Tmp{$k}->{delta};
		}
		delete $Tmp{$k};
	}

	for ($i = $len_same; $i <= $len_b; $i++) {
		my $k = "$this->[$i];$i";
		$Tmp{$k}->{stime} = $v;
		if (defined $d) {
			$Tmp{$k}->{delta} += $i == $len_b ? $d : 0;
		}
	}

        return $this;
}

# parse input
my @Data;
my @SortedData;
my $last = [];
my $time = 0;
my $delta = undef;
my $ignored = 0;
my $line;
my $maxdelta = 1;

# reverse if needed
foreach (<>) {
	chomp;
	$line = $_;
	if ($stackreverse) {
		# there may be an extra samples column for differentials
		# XXX todo: redo these REs as one. It's repeated below.
		my($stack, $samples) = (/^(.*)\s+?(\d+(?:\.\d*)?)$/);
		my $samples2 = undef;
		if ($stack =~ /^(.*)\s+?(\d+(?:\.\d*)?)$/) {
			$samples2 = $samples;
			($stack, $samples) = $stack =~ (/^(.*)\s+?(\d+(?:\.\d*)?)$/);
			unshift @Data, join(";", reverse split(";", $stack)) . " $samples $samples2";
		} else {
			unshift @Data, join(";", reverse split(";", $stack)) . " $samples";
		}
	} else {
		unshift @Data, $line;
	}
}

if ($flamechart) {
	# In flame chart mode, just reverse the data so time moves from left to right.
	@SortedData = reverse @Data;
} else {
	@SortedData = sort @Data;
}

# process and merge frames
foreach (@SortedData) {
	chomp;
	# process: folded_stack count
	# eg: func_a;func_b;func_c 31
	my ($stack, $samples) = (/^(.*)\s+?(\d+(?:\.\d*)?)$/);
	unless (defined $samples and defined $stack) {
		++$ignored;
		next;
	}

	# there may be an extra samples column for differentials:
	my $samples2 = undef;
	if ($stack =~ /^(.*)\s+?(\d+(?:\.\d*)?)$/) {
		$samples2 = $samples;
		($stack, $samples) = $stack =~ (/^(.*)\s+?(\d+(?:\.\d*)?)$/);
	}
	$delta = undef;
	if (defined $samples2) {
		$delta = $samples2 - $samples;
		$maxdelta = abs($delta) if abs($delta) > $maxdelta;
	}

	# for chain graphs, annotate waker frames with "_[w]", for later
	# coloring. This is a hack, but has a precedent ("_[k]" from perf).
	if ($colors eq "chain") {
		my @parts = split ";--;", $stack;
		my @newparts = ();
		$stack = shift @parts;
		$stack .= ";--;";
		foreach my $part (@parts) {
			$part =~ s/;/_[w];/g;
			$part .= "_[w]";
			push @newparts, $part;
		}
		$stack .= join ";--;", @parts;
	}

	# merge frames and populate %Node:
	$last = flow($last, [ '', split ";", $stack ], $time, $delta);

	if (defined $samples2) {
		$time += $samples2;
	} else {
		$time += $samples;
	}
}
flow($last, [], $time, $delta);

if ($countname eq "samples") {
	# If $countname is used, it's likely that we're not measuring in stack samples
	# (e.g. time could be the unit), so don't warn.
	#warn "Stack count is low ($time). Did something go wrong?\n" if $time < 100;
}

warn "Ignored $ignored lines with invalid format\n" if $ignored;
unless ($time) {
	warn "ERROR: No stack counts found\n";
	my $im = SVG->new();
	# emit an error message SVG, for tools automating flamegraph use
	my $imageheight = $fontsize * 5;
	$im->header($imagewidth, $imageheight);
	$im->stringTTF(undef, int($imagewidth / 2), $fontsize * 2,
	    "ERROR: No valid input provided to flamegraph.pl.");
	print $im->svg;
	exit 2;
}
if ($timemax and $timemax < $time) {
	warn "Specified --total $timemax is less than actual total $time, so ignored\n"
	if $timemax/$time > 0.02; # only warn is significant (e.g., not rounding etc)
	undef $timemax;
}
$timemax ||= $time;

my $widthpertime = ($imagewidth - 2 * $xpad) / $timemax;

# Treat as a percentage of time if the string ends in a "%".
my $minwidth_time;
if ($minwidth =~ /%$/) {
	$minwidth_time = $timemax * $minwidth_f / 100;
} else {
	$minwidth_time = $minwidth_f / $widthpertime;
}

# prune blocks that are too narrow and determine max depth
while (my ($id, $node) = each %Node) {
	my ($func, $depth, $etime) = split ";", $id;
	my $stime = $node->{stime};
	die "missing start for $id" if not defined $stime;

	if (($etime-$stime) < $minwidth_time) {
		delete $Node{$id};
		next;
	}
	$depthmax = $depth if $depth > $depthmax;
}

# draw canvas, and embed interactive JavaScript program
my $imageheight = (($depthmax + 1) * $frameheight) + $ypad1 + $ypad2;
$imageheight += $ypad3 if $subtitletext ne "";
my $titlesize = $fontsize + 5;
my $im = SVG->new();
my ($black, $vdgrey, $dgrey) = (
	$im->colorAllocate(0, 0, 0),
	$im->colorAllocate(160, 160, 160),
	$im->colorAllocate(200, 200, 200),
    );
$im->header($imagewidth, $imageheight);
my $inc = <<INC;
<defs>
	<linearGradient id="background" y1="0" y2="1" x1="0" x2="0" >
		<stop stop-color="$bgcolor1" offset="5%" />
		<stop stop-color="$bgcolor2" offset="95%" />
	</linearGradient>
</defs>
<style type="text/css">
	text { font-family:$fonttype; font-size:${fontsize}px; fill:$black; }
	#search, #ignorecase { opacity:0.6; cursor:pointer; }
	#search:hover, #search.show, #ignorecase:hover, #ignorecase.show { opacity:1; }
	#subtitle { text-anchor:middle; font-color:$vdgrey; }
	#title { text-anchor:middle; font-size:${titlesize}px}
	#unzoom { cursor:pointer; }
	#frames > *:hover { stroke:black; stroke-width:0.5; cursor:pointer; }
	.hide { display:none; }
	.parent { opacity:0.5; }
</style>
<script type="text/ecmascript">
<![CDATA[
	"use strict";
	var details, searchbtn, unzoombtn, matchedtxt, svg, searching, currentSearchTerm, ignorecase, ignorecaseBtn;
	function init(evt) {
		details = document.getElementById("details").firstChild;
		searchbtn = document.getElementById("search");
		ignorecaseBtn = document.getElementById("ignorecase");
		unzoombtn = document.getElementById("unzoom");
		matchedtxt = document.getElementById("matched");
		svg = document.getElementsByTagName("svg")[0];
		searching = 0;
		currentSearchTerm = null;

		// use GET parameters to restore a flamegraphs state.
		var params = get_params();
		if (params.x && params.y)
			zoom(find_group(document.querySelector('[x="' + params.x + '"][y="' + params.y + '"]')));
                if (params.s) search(params.s);
	}

	// event listeners
	window.addEventListener("click", function(e) {
		var target = find_group(e.target);
		if (target) {
			if (target.nodeName == "a") {
				if (e.ctrlKey === false) return;
				e.preventDefault();
			}
			if (target.classList.contains("parent")) unzoom(true);
			zoom(target);
			if (!document.querySelector('.parent')) {
				// we have basically done a clearzoom so clear the url
				var params = get_params();
				if (params.x) delete params.x;
				if (params.y) delete params.y;
				history.replaceState(null, null, parse_params(params));
				unzoombtn.classList.add("hide");
				return;
			}

			// set parameters for zoom state
			var el = target.querySelector("rect");
			if (el && el.attributes && el.attributes.y && el.attributes._orig_x) {
				var params = get_params()
				params.x = el.attributes._orig_x.value;
				params.y = el.attributes.y.value;
				history.replaceState(null, null, parse_params(params));
			}
		}
		else if (e.target.id == "unzoom") clearzoom();
		else if (e.target.id == "search") search_prompt();
		else if (e.target.id == "ignorecase") toggle_ignorecase();
	}, false)

	// mouse-over for info
	// show
	window.addEventListener("mouseover", function(e) {
		var target = find_group(e.target);
		if (target) details.nodeValue = "$nametype " + g_to_text(target);
	}, false)

	// clear
	window.addEventListener("mouseout", function(e) {
		var target = find_group(e.target);
		if (target) details.nodeValue = ' ';
	}, false)

	window.addEventListener("contextmenu", function(evt) {
		var target = find_group(evt.target);
		if (target) {
			var strToAlert = "";
			var width = parseFloat(target.children[1].getAttribute("width"));
			var height = parseFloat(target.children[1].getAttribute("height"));
			var xmin = parseFloat(target.children[1].getAttribute("x"));
			var xmax = parseFloat(xmin + width);
			var ymin = parseFloat(target.children[1].getAttribute("y"));

			// XXX: Workaround for JavaScript float issues (fix me)
			var fudge = 0.0001;
			var stack = [];
			var el = document.getElementById("frames").children;
			for (var i = 0; i < el.length; i++) {
				var e = el[i];
				var a = find_child(e, "rect").attributes;
				var ex = parseFloat(a.x.value);
				var ew = parseFloat(a.width.value);
				var upstack;
				if ($inverted == 0) {
					// non-inverted
					upstack = parseFloat(a.y.value) > ymin - height;
				} else {
					// inverted
					upstack = parseFloat(a.y.value) < ymin + height;
				}
				if (upstack) {
					if (ex <= xmin && (ex+ew+fudge) >= xmax) {
						stack.push({
							y: parseFloat(a.y.value),
							title: e.children[0].innerHTML,
						});
					}
				}
			}
			
			stack.sort((a, b) => {
				if (a.y < b.y) { return -1; }
				else if (a.y > b.y) { return 1; }
				else { return 0; }
			});

			for (var i = 0; i < stack.length; i++) {
				strToAlert += stack[i].title + "\\n";
			}

			alert(strToAlert);
		}
		evt.preventDefault();
	}, false);

	// ctrl-F for search
	// ctrl-I to toggle case-sensitive search
	window.addEventListener("keydown",function (e) {
		if (e.keyCode === 114 || (e.ctrlKey && e.keyCode === 70)) {
			e.preventDefault();
			search_prompt();
		}
		else if (e.ctrlKey && e.keyCode === 73) {
			e.preventDefault();
			toggle_ignorecase();
		}
	}, false)

	// functions
	function get_params() {
		var params = {};
		var paramsarr = window.location.search.substr(1).split('&');
		for (var i = 0; i < paramsarr.length; ++i) {
			var tmp = paramsarr[i].split("=");
			if (!tmp[0] || !tmp[1]) continue;
			params[tmp[0]]  = decodeURIComponent(tmp[1]);
		}
		return params;
	}
	function parse_params(params) {
		var uri = "?";
		for (var key in params) {
			uri += key + '=' + encodeURIComponent(params[key]) + '&';
		}
		if (uri.slice(-1) == "&")
			uri = uri.substring(0, uri.length - 1);
		if (uri == '?')
			uri = window.location.href.split('?')[0];
		return uri;
	}
	function find_child(node, selector) {
		var children = node.querySelectorAll(selector);
		if (children.length) return children[0];
	}
	function find_group(node) {
		var parent = node.parentElement;
		if (!parent) return;
		if (parent.id == "frames") return node;
		return find_group(parent);
	}
	function orig_save(e, attr, val) {
		if (e.attributes["_orig_" + attr] != undefined) return;
		if (e.attributes[attr] == undefined) return;
		if (val == undefined) val = e.attributes[attr].value;
		e.setAttribute("_orig_" + attr, val);
	}
	function orig_load(e, attr) {
		if (e.attributes["_orig_"+attr] == undefined) return;
		e.attributes[attr].value = e.attributes["_orig_" + attr].value;
		e.removeAttribute("_orig_"+attr);
	}
	function g_to_text(e) {
		var text = find_child(e, "title").firstChild.nodeValue;
		return (text)
	}
	function g_to_func(e) {
		var func = g_to_text(e);
		// if there's any manipulation we want to do to the function
		// name before it's searched, do it here before returning.
		return (func);
	}
	function update_text(e) {
		var r = find_child(e, "rect");
		var t = find_child(e, "text");
		var w = parseFloat(r.attributes.width.value) -3;
		var txt = find_child(e, "title").textContent.replace(/\\([^(]*\\)\$/,"");
		t.attributes.x.value = parseFloat(r.attributes.x.value) + 3;

		// Smaller than this size won't fit anything
		if (w < 2 * $fontsize * $fontwidth) {
			t.textContent = "";
			return;
		}

		t.textContent = txt;
		var sl = t.getSubStringLength(0, txt.length);
		// check if only whitespace or if we can fit the entire string into width w
		if (/^ *\$/.test(txt) || sl < w)
			return;

		// this isn't perfect, but gives a good starting point
		// and avoids calling getSubStringLength too often
		var start = Math.floor((w/sl) * txt.length);
		for (var x = start; x > 0; x = x-2) {
			if (t.getSubStringLength(0, x + 2) <= w) {
				t.textContent = txt.substring(0, x) + "..";
				return;
			}
		}
		t.textContent = "";
	}

	// zoom
	function zoom_reset(e) {
		if (e.attributes != undefined) {
			orig_load(e, "x");
			orig_load(e, "width");
		}
		if (e.childNodes == undefined) return;
		for (var i = 0, c = e.childNodes; i < c.length; i++) {
			zoom_reset(c[i]);
		}
	}
	function zoom_child(e, x, ratio) {
		if (e.attributes != undefined) {
			if (e.attributes.x != undefined) {
				orig_save(e, "x");
				e.attributes.x.value = (parseFloat(e.attributes.x.value) - x - $xpad) * ratio + $xpad;
				if (e.tagName == "text")
					e.attributes.x.value = find_child(e.parentNode, "rect[x]").attributes.x.value + 3;
			}
			if (e.attributes.width != undefined) {
				orig_save(e, "width");
				e.attributes.width.value = parseFloat(e.attributes.width.value) * ratio;
			}
		}

		if (e.childNodes == undefined) return;
		for (var i = 0, c = e.childNodes; i < c.length; i++) {
			zoom_child(c[i], x - $xpad, ratio);
		}
	}
	function zoom_parent(e) {
		if (e.attributes) {
			if (e.attributes.x != undefined) {
				orig_save(e, "x");
				e.attributes.x.value = $xpad;
			}
			if (e.attributes.width != undefined) {
				orig_save(e, "width");
				e.attributes.width.value = parseInt(svg.width.baseVal.value) - ($xpad * 2);
			}
		}
		if (e.childNodes == undefined) return;
		for (var i = 0, c = e.childNodes; i < c.length; i++) {
			zoom_parent(c[i]);
		}
	}
	function zoom(node) {
		var attr = find_child(node, "rect").attributes;
		var width = parseFloat(attr.width.value);
		var xmin = parseFloat(attr.x.value);
		var xmax = parseFloat(xmin + width);
		var ymin = parseFloat(attr.y.value);
		var ratio = (svg.width.baseVal.value - 2 * $xpad) / width;

		// XXX: Workaround for JavaScript float issues (fix me)
		var fudge = 0.0001;

		unzoombtn.classList.remove("hide");

		var el = document.getElementById("frames").children;
		for (var i = 0; i < el.length; i++) {
			var e = el[i];
			var a = find_child(e, "rect").attributes;
			var ex = parseFloat(a.x.value);
			var ew = parseFloat(a.width.value);
			var upstack;
			// Is it an ancestor
			if ($inverted == 0) {
				upstack = parseFloat(a.y.value) > ymin;
			} else {
				upstack = parseFloat(a.y.value) < ymin;
			}
			if (upstack) {
				// Direct ancestor
				if (ex <= xmin && (ex+ew+fudge) >= xmax) {
					e.classList.add("parent");
					zoom_parent(e);
					update_text(e);
				}
				// not in current path
				else
					e.classList.add("hide");
			}
			// Children maybe
			else {
				// no common path
				if (ex < xmin || ex + fudge >= xmax) {
					e.classList.add("hide");
				}
				else {
					zoom_child(e, xmin, ratio);
					update_text(e);
				}
			}
		}
		search();
	}
	function unzoom(dont_update_text) {
		unzoombtn.classList.add("hide");
		var el = document.getElementById("frames").children;
		for(var i = 0; i < el.length; i++) {
			el[i].classList.remove("parent");
			el[i].classList.remove("hide");
			zoom_reset(el[i]);
			if(!dont_update_text) update_text(el[i]);
		}
		search();
	}
	function clearzoom() {
		unzoom();

		// remove zoom state
		var params = get_params();
		if (params.x) delete params.x;
		if (params.y) delete params.y;
		history.replaceState(null, null, parse_params(params));
	}

	// search
	function toggle_ignorecase() {
		ignorecase = !ignorecase;
		if (ignorecase) {
			ignorecaseBtn.classList.add("show");
		} else {
			ignorecaseBtn.classList.remove("show");
		}
		reset_search();
		search();
	}
	function reset_search() {
		var el = document.querySelectorAll("#frames rect");
		for (var i = 0; i < el.length; i++) {
			orig_load(el[i], "fill")
		}
		var params = get_params();
		delete params.s;
		history.replaceState(null, null, parse_params(params));
	}
	function search_prompt() {
		if (!searching) {
			var term = prompt("Enter a search term (regexp " +
			    "allowed, eg: ^ext4_)"
			    + (ignorecase ? ", ignoring case" : "")
			    + "\\nPress Ctrl-i to toggle case sensitivity", "");
			if (term != null) search(term);
		} else {
			reset_search();
			searching = 0;
			currentSearchTerm = null;
			searchbtn.classList.remove("show");
			searchbtn.firstChild.nodeValue = "Search"
			matchedtxt.classList.add("hide");
			matchedtxt.firstChild.nodeValue = ""
		}
	}
	function search(term) {
		if (term) currentSearchTerm = term;

		var re = new RegExp(currentSearchTerm, ignorecase ? 'i' : '');
		var el = document.getElementById("frames").children;
		var matches = new Object();
		var maxwidth = 0;
		for (var i = 0; i < el.length; i++) {
			var e = el[i];
			var func = g_to_func(e);
			var rect = find_child(e, "rect");
			if (func == null || rect == null)
				continue;

			// Save max width. Only works as we have a root frame
			var w = parseFloat(rect.attributes.width.value);
			if (w > maxwidth)
				maxwidth = w;

			if (func.match(re)) {
				// highlight
				var x = parseFloat(rect.attributes.x.value);
				orig_save(rect, "fill");
				rect.attributes.fill.value = "$searchcolor";

				// remember matches
				if (matches[x] == undefined) {
					matches[x] = w;
				} else {
					if (w > matches[x]) {
						// overwrite with parent
						matches[x] = w;
					}
				}
				searching = 1;
			}
		}
		if (!searching)
			return;
		var params = get_params();
		params.s = currentSearchTerm;
		history.replaceState(null, null, parse_params(params));

		searchbtn.classList.add("show");
		searchbtn.firstChild.nodeValue = "Reset Search";

		// calculate percent matched, excluding vertical overlap
		var count = 0;
		var lastx = -1;
		var lastw = 0;
		var keys = Array();
		for (k in matches) {
			if (matches.hasOwnProperty(k))
				keys.push(k);
		}
		// sort the matched frames by their x location
		// ascending, then width descending
		keys.sort(function(a, b){
			return a - b;
		});
		// Step through frames saving only the biggest bottom-up frames
		// thanks to the sort order. This relies on the tree property
		// where children are always smaller than their parents.
		var fudge = 0.0001;	// JavaScript floating point
		for (var k in keys) {
			var x = parseFloat(keys[k]);
			var w = matches[keys[k]];
			if (x >= lastx + lastw - fudge) {
				count += w;
				lastx = x;
				lastw = w;
			}
		}
		// display matched percent
		matchedtxt.classList.remove("hide");
		var pct = 100 * count / maxwidth;
		if (pct != 100) pct = pct.toFixed(1)
		matchedtxt.firstChild.nodeValue = "Matched: " + pct + "%";
	}
]]>
</script>
INC
$im->include($inc);
$im->filledRectangle(0, 0, $imagewidth, $imageheight, 'url(#background)');
$im->stringTTF("title", int($imagewidth / 2), $fontsize * 2, $titletext);
$im->stringTTF("subtitle", int($imagewidth / 2), $fontsize * 4, $subtitletext) if $subtitletext ne "";
$im->stringTTF("details", $xpad, $imageheight - ($ypad2 / 2), " ");
$im->stringTTF("unzoom", $xpad, $fontsize * 2, "Reset Zoom", 'class="hide"');
$im->stringTTF("search", $imagewidth - $xpad - 100, $fontsize * 2, "Search");
$im->stringTTF("ignorecase", $imagewidth - $xpad - 16, $fontsize * 2, "ic");
$im->stringTTF("matched", $imagewidth - $xpad - 100, $imageheight - ($ypad2 / 2), " ");

if ($palette) {
	read_palette();
}

# draw frames
$im->group_start({id => "frames"});
while (my ($id, $node) = each %Node) {
	my ($func, $depth, $etime) = split ";", $id;
	my $stime = $node->{stime};
	my $delta = $node->{delta};

	$etime = $timemax if $func eq "" and $depth == 0;

	my $x1 = $xpad + $stime * $widthpertime;
	my $x2 = $xpad + $etime * $widthpertime;
	my ($y1, $y2);
	unless ($inverted) {
		$y1 = $imageheight - $ypad2 - ($depth + 1) * $frameheight + $framepad;
		$y2 = $imageheight - $ypad2 - $depth * $frameheight;
	} else {
		$y1 = $ypad1 + $depth * $frameheight;
		$y2 = $ypad1 + ($depth + 1) * $frameheight - $framepad;
	}

	# Add commas per perlfaq5:
	# https://perldoc.perl.org/perlfaq5#How-can-I-output-my-numbers-with-commas-added?
	my $samples = sprintf "%.0f", ($etime - $stime) * $factor;
	(my $samples_txt = $samples)
		=~ s/(^[-+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/$1,/g;

	my $info;
	if ($func eq "" and $depth == 0) {
		$info = "all ($samples_txt $countname, 100%)";
	} else {
		my $pct = sprintf "%.2f", ((100 * $samples) / ($timemax * $factor));
		my $escaped_func = $func;
		# clean up SVG breaking characters:
		$escaped_func =~ s/&/&amp;/g;
		$escaped_func =~ s/</&lt;/g;
		$escaped_func =~ s/>/&gt;/g;
		$escaped_func =~ s/"/&quot;/g;
		$escaped_func =~ s/_\[[kwij]\]$//;	# strip any annotation
		unless (defined $delta) {
			$info = "$escaped_func ($samples_txt $countname, $pct%)";
		} else {
			my $d = $negate ? -$delta : $delta;
			my $deltapct = sprintf "%.2f", ((100 * $d) / ($timemax * $factor));
			$deltapct = $d > 0 ? "+$deltapct" : $deltapct;
			$info = "$escaped_func ($samples_txt $countname, $pct%; $deltapct%)";
		}
	}

	my $nameattr = { %{ $nameattr{$func}||{} } }; # shallow clone
	$nameattr->{title}       ||= $info;
	$im->group_start($nameattr);

	my $color;
	if ($func eq "--") {
		$color = $vdgrey;
	} elsif ($func eq "-") {
		$color = $dgrey;
	} elsif (defined $delta) {
		$color = color_scale($delta, $maxdelta);
	} elsif ($palette) {
		$color = color_map($colors, $func, ($x2 - $x1));
	} else {
		$color = color($colors, $hash, $func, ($x2 - $x1));
	}
	$im->filledRectangle($x1, $y1, $x2, $y2, $color, 'rx="2" ry="2"');

	my $chars = int( ($x2 - $x1) / ($fontsize * $fontwidth));
	my $text = "";
	if ($chars >= 3) { # room for one char plus two dots
		$func =~ s/_\[[kwij]\]$//;	# strip any annotation
		$text = substr $func, 0, $chars;
		substr($text, -2, 2) = ".." if $chars < length $func;
		$text =~ s/&/&amp;/g;
		$text =~ s/</&lt;/g;
		$text =~ s/>/&gt;/g;
	}
	$im->stringTTF(undef, $x1 + 3, 3 + ($y1 + $y2) / 2, $text);

	$im->group_end($nameattr);
}
$im->group_end();

print $im->svg;

if ($palette) {
	write_palette();
}

# vim: ts=8 sts=8 sw=8 noexpandtab