use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'PDFJ',
    'VERSION_FROM' => 'PDFJ.pm', # finds $VERSION
    'PM' => {
    	'PDFJ.pm' => '$(INST_LIBDIR)/PDFJ.pm',
    	'PDFJ/Object.pm' => '$(INST_LIBDIR)/PDFJ/Object.pm',
    	'PDFJ/Unicode.pm' => '$(INST_LIBDIR)/PDFJ/Unicode.pm',
    	'PDFJ/E2U.pm' => '$(INST_LIBDIR)/PDFJ/E2U.pm',
    	'PDFJ/S2U.pm' => '$(INST_LIBDIR)/PDFJ/S2U.pm',
    	'PDFJ/U2C.pm' => '$(INST_LIBDIR)/PDFJ/U2C.pm',
    	'PDFJ/TTF.pm' => '$(INST_LIBDIR)/PDFJ/TTF.pm',
    	'PDFJ/OTF.pm' => '$(INST_LIBDIR)/PDFJ/OTF.pm',
    	'PDFJ/Type1.pm' => '$(INST_LIBDIR)/PDFJ/Type1.pm',
    	'PDFJ/CFF.pm' => '$(INST_LIBDIR)/PDFJ/CFF.pm',
    	'PDFJ/Shape.pm' => '$(INST_LIBDIR)/PDFJ/Shape.pm',
    	'PDFJ/Matrix.pm' => '$(INST_LIBDIR)/PDFJ/Matrix.pm',
    	'PDFJ/Tree.pm' => '$(INST_LIBDIR)/PDFJ/Tree.pm',
    	'PDFJ/Form.pm' => '$(INST_LIBDIR)/PDFJ/Form.pm',
    	'PDFJ/PNG.pm' => '$(INST_LIBDIR)/PDFJ/PNG.pm',
    	'XPDFJ.pm' => '$(INST_LIBDIR)/XPDFJ.pm',
    	},
);
