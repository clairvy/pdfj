<!-- 
stdfontsH.inc : standard font definitions for XPDFJ 
2003 <nakajima@netstock.co.jp>
-->
<do>

<eval>
	$Args{asize} ||= 1;
	
	$Args{normalmincho} ||= 'Ryumin-Light';
	$Args{boldmincho} ||= 'GothicBBB-Medium';
	$Args{normalgothic} ||= 'GothicBBB-Medium';
	$Args{boldgothic} ||= 'GothicBBB-Medium';

	$Args{normalminchoenc} ||= 'UniJIS-UCS2-HW-V';
	$Args{boldminchoenc} ||= 'UniJIS-UCS2-HW-V';
	$Args{normalgothicenc} ||= 'UniJIS-UCS2-HW-V';
	$Args{boldgothicenc} ||= 'UniJIS-UCS2-HW-V';

	for my $name(qw(normalminchoenc boldminchoenc normalgothicenc boldgothicenc)) {
		$Args{$name} =~ s/-[HV]$/-V/ or $Args{$name} =~ s/$/-V/;
	}
</eval>

<new_font setvar="$FontV{mincho}" basefont="$Args{normalmincho}" 
	encoding="$Args{normalminchoenc}"/>
<new_font setvar="$FontV{mincho_bold}" basefont="$Args{boldmincho}" 
	encoding="$Args{boldminchoenc}"/>
<new_font setvar="$FontV{mincho_times}" basefont="$Args{normalmincho}" 
	encoding="$Args{normalminchoenc}" abasefont="Times-Roman" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{mincho_times_italic}" basefont="$Args{normalmincho}" 
	encoding="$Args{normalminchoenc}" abasefont="Times-Italic" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{mincho_times_bold}" basefont="$Args{boldmincho}" 
	encoding="$Args{boldminchoenc}" abasefont="Times-Bold" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{mincho_times_bolditalic}" basefont="$Args{boldmincho}" 
	encoding="$Args{boldminchoenc}" abasefont="Times-BoldItalic" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>

<italic base="$FontV{mincho_times}" decorated="$FontV{mincho_times_italic}"/>
<italic base="$FontV{mincho_times_bold}" decorated="$FontV{mincho_times_bolditalic}"/>
<bold base="$FontV{mincho_times}" decorated="$FontV{mincho_times_bold}"/>
<bold base="$FontV{mincho_times_italic}" decorated="$FontV{mincho_times_bolditalic}"/>

<new_font setvar="$FontV{gothic}" basefont="$Args{normalgothic}" 
	encoding="$Args{normalgothicenc}"/>
<new_font setvar="$FontV{gothic_bold}" basefont="$Args{boldgothic}" 
	encoding="$Args{boldgothicenc}"/>
<new_font setvar="$FontV{gothic_helvetica}" basefont="$Args{normalgothic}" 
	encoding="$Args{normalgothicenc}" abasefont="Helvetica" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{gothic_helvetica_oblique}" basefont="$Args{normalgothic}" 
	encoding="$Args{normalgothicenc}" abasefont="Helvetica-Oblique" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{gothic_helvetica_bold}" basefont="$Args{boldgothic}" 
	encoding="$Args{boldgothicenc}" abasefont="Helvetica-Bold" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>
<new_font setvar="$FontV{gothic_helvetica_boldoblique}" basefont="$Args{boldgothic}" 
	encoding="$Args{boldgothicenc}" abasefont="Helvetica-BoldOblique" 
	aencoding="WinAnsiEncoding" asize="$Args{asize}"/>

<italic base="$FontV{gothic_helvetica}" decorated="$FontV{gothic_helvetica_oblique}"/>
<italic base="$FontV{gothic_helvetica_bold}" decorated="$FontV{gothic_helvetica_boldoblique}"/>
<bold base="$FontV{gothic_helvetica}" decorated="$FontV{gothic_helvetica_bold}"/>
<bold base="$FontV{gothic_helvetica_oblique}" decorated="$FontV{gothic_helvetica_boldoblique}"/>

<italic base="$FontV{mincho}" decorated="$FontV{mincho}"/>
<bold base="$FontV{mincho}" decorated="$FontV{mincho_bold}"/>
<italic base="$FontV{gothic}" decorated="$FontV{gothic}"/>
<bold base="$FontV{gothic}" decorated="$FontV{gothic_bold}"/>

<eval>
	my $name = $Args{defaultfont} || 'mincho_times';
	die qq(missing \$FontV{$name}) unless $FontV{$name};
	$Font{default} = $FontV{$name};

	$Doc{Fontdirection} = 'V';
</eval>

</do>
