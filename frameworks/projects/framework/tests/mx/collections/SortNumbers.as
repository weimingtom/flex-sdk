////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package mx.collections {
    import org.flexunit.asserts.*;

    public class SortNumbers
	{

        protected var ac:ArrayCollection;
		
		[Before]
		public function setUp():void
		{
			ac = new ArrayCollection();
		}
		
		[After]
		public function tearDown():void
		{
			ac = null;
		}
		
		protected function addNumbers():void
		{
			ac.addItem(1);
			ac.addItem(2);
		}
		
		[Test]
		public function nullSort():void
		{
			addNumbers();
			ac.sort = null;
			ac.refresh();
			
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
		}	
		
		[Test]
		public function emptySort():void
		{
			addNumbers();
			ac.sort = new Sort();
			ac.refresh();
			
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
		}
		
		[Test]
		public function reverseSort():void
		{
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			addNumbers();
			ac.sort = sort;
			ac.refresh();
			
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 2);
			assertEquals("Second element not correct", ac[1], 1);
		}
		
		[Test]
		public function sortNoRefresh():void
		{
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			addNumbers();
			ac.sort = sort;
			
			// Short should not take effect
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
		}
		
		[Test]
		public function nullSortNoRefresh():void
		{
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			addNumbers();
			ac.sort = sort;
			ac.refresh();
			ac.sort = null;
			
			// Sort should be in effect
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 2);
			assertEquals("Second element not correct", ac[1], 1);
			
			ac.refresh();
			
			// and back to original
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
		}
		
		[Test]
		public function sortDoubleRefresh():void
		{
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			addNumbers();
			ac.sort = sort;
			ac.refresh();
			ac.sort = null;
			ac.refresh();
			
			// Sort should not be in effect
			assertEquals("Length is not two", ac.length, 2);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
		}
		
		// RTEs in APache flex 4.9.1
		[Test]
		public function sortAddAfterNullNoRefresh():void
		{
			addNumbers();
			
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			ac.sort = sort;
			ac.refresh();
			ac.sort = null;
			addNumbers();
			
			// Sort should be in effect and first 2 items sorted
			// item added after are not sorted
			assertEquals("Length is not four", ac.length, 4);
			assertEquals("First element not correct", ac[0], 2);
			assertEquals("Second element not correct", ac[1], 1);
			assertEquals("Third element not correct", ac[2], 1);
			assertEquals("Fourth element not correct", ac[3], 2);
			
			ac.refresh();
			
			// and back to being unsorted
			assertEquals("Length is not four", ac.length, 4);
			assertEquals("First element not correct", ac[0], 1);
			assertEquals("Second element not correct", ac[1], 2);
			assertEquals("Third element not correct", ac[2], 1);
			assertEquals("Fourth element not correct", ac[3], 2);
		}
		
		// RTEs in Apache Flex 4.9.1
		[Test]
		public function sortRemoveAfterNullNoRefresh():void
		{
			addNumbers();
			
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			ac.sort = sort;
			ac.refresh();
			ac.sort = null;
			
			assertEquals("Length is not two", ac.length, 2);
			
			ac.removeItemAt(0); // still sorted so 2 is removed leaving 1
			assertEquals("Length is not one", ac.length, 1);
			assertEquals("First element not correct", ac[0], 1);
			
			ac.refresh();
			
			// still the same
			assertEquals("Length is not one", ac.length, 1);
			assertEquals("First element not correct", ac[0], 1);
		}
		
		[Test]
		public function sortIncludingDuplicates():void
		{
			addNumbers();
			addNumbers();
			
			var sort:Sort = new Sort();			
			sort.fields = [new SortField(null, false, true, true)];
			ac.sort = sort;
			ac.refresh();
			
			assertEquals("Length is not four", ac.length, 4);
			
			assertEquals("First element not correct", ac[0], 2);
			assertEquals("Second element not correct", ac[1], 2);
			assertEquals("Third element not correct", ac[2], 1);
			assertEquals("Fourth element not correct", ac[3], 1);		
		}
		
	}
}